class Gws::Gkan::Manage::Attendance::TimeCardsController < ApplicationController
  include Gws::BaseFilter
  include Gws::CrudFilter
  include Gws::Attendance::TimeCardFilter
  include Gws::Gkan::WorkflowFilter

  model Gws::Gkan::Attendance::TimeCard

  append_view_path "app/views/gws/gkan/attendance/time_cards/form"

  navi_view "gws/gkan/manage/attendance/main/navi"

  # グループと一覧
  before_action :set_group, only: [:index]
  before_action :set_active_year_range, only: [:index]
  before_action :set_fiscal_year, only: [:index]

  # 個別タイムカードの詳細
  before_action :set_item, only: [:show, :delete, :destroy, :time, :detail, :memo, :travel_cost, :location, :night_shift]
  before_action :set_cur_month, only: [:show, :delete, :destroy, :time, :detail, :memo, :travel_cost, :location, :night_shift]
  before_action :set_record, only: [:time, :detail, :memo, :travel_cost, :location, :night_shift]
  before_action :set_overtime_files, only: [:show, :overtime_files], if: -> { @item }
  before_action :set_leave_files, only: [:show, :leave_files], if: -> { @item }

  helper_method :months
  helper_method :fiscal_year_options
  helper_method :render_over_time

  private

  def set_crumbs
    @crumbs << [ @cur_site.menu_gkan_attendance_label || t('modules.gws/gkan/attendance'), gws_gkan_attendance_main_path ]
    @crumbs << [ t('modules.gws/gkan/manage/attendance'), gws_gkan_manage_attendance_main_path ]
    @crumbs << [ t('modules.gws/gkan/manage/attendance/time_cards'), { action: :index } ]
  end

  def set_group
    @group = Gws::Group.find(params[:group]) rescue nil
    @group ||= @cur_group
    @group ||= @cur_site
  end

  def set_active_year_range
    current = @cur_site.fiscal_year
    lower = current - @cur_site.attendance_management_year
    upper = current + @cur_site.attendance_management_year
    @active_year_range = (lower..upper)
  end

  def set_fiscal_year
    if params[:fiscal_year] =~ /^\d{4}$/
      @fiscal_year = params[:fiscal_year].to_i
    else
      @fiscal_year = @cur_site.fiscal_year
    end
    raise "404" if !@active_year_range.include?(@fiscal_year)
  end

  def fiscal_year_options
    @active_year_range.map { |y| ["#{y}#{I18n.t("ss.fiscal_year")}", y] }.reverse
  end

  def months
    @cur_site.fiscal_months
  end

  def set_cur_month
    @cur_month = @item.date
  end

  def set_record
    @cur_date = @cur_month.change(day: params[:day].to_i)
    @record = @item.records.where(date: @cur_date).first_or_create
  end

  def set_overtime_files
    @overtime_files = {}
    items = Gws::Gkan::Attendance::OvertimeFile.site(@cur_site).and(
      { "user_id" => @item.user_id },
      { "state" => "approve" },
      { "date" => { "$gte" => @cur_month } },
      { "date" => { "$lte" => @cur_month.end_of_month } })
    items.each do |item|
      date = item.date.in_time_zone
      @overtime_files[date] ||= []
      @overtime_files[date] << item
    end
  end

  def set_leave_files
    @leave_files = {}
    items = Gws::Gkan::Attendance::LeaveFile.site(@cur_site).and(
      { "user_id" => @item.user_id },
      { "state" => "approve" },
      { "$or" => [
        { "close_at" => { "$gte" => @cur_month } },
        { "start_at" => { "$lte" => @cur_month.end_of_month } }
      ]})
    items.each do |item|
      start_date = item.start_at.to_date
      close_date = item.close_at.to_date
      (start_date..close_date).each do |date|
        date = date.in_time_zone
        @leave_files[date] ||= []
        @leave_files[date] << item
      end
    end
  end

  def format_minutes(minutes)
    (minutes.to_i > 0) ? "#{minutes / 60}:#{format("%02d", (minutes % 60))}" : "--:--"
  end

  def format_minutes2(minutes)
    if minutes.to_i >= 0
      "#{minutes / 60}:#{format("%02d", (minutes % 60))}"
    else
      minutes = minutes * -1
      "-#{minutes / 60}:#{format("%02d", (minutes % 60))}"
    end
  end

  def render_over_time(date, record)
    if record.over_minutes.nil?
      return format_minutes(0)
    end

    files = @overtime_files[date]
    over_minutes1 = record.over_minutes.to_i           # タイムカードの時間外
    over_minutes2 = files.to_a.map(&:over_minutes).sum # 申請の時間外
    diff_minutes = over_minutes1 - over_minutes2       # 差分

    if files.blank?
      return format_minutes(over_minutes1)
    end

    h = []
    h << format_minutes(over_minutes1)
    h << " ( "
    h << view_context.link_to(format_minutes(over_minutes2), { action: :overtime_files, day: format('%02d', date.day) }, { class: "ajax-box" })
    h << " | "
    h << format_minutes2(diff_minutes)
    h << " )"
    h.join.html_safe
  end

  def crud_redirect_url
    { action: :show }
  end

  public

  def index
    raise "403" unless Gws::Gkan::Manage::Attendance.allowed?(:use, @cur_user, site: @cur_site)

    @users = @group.users.active.order_by_title(@cur_site)
    @time_cards = {}

    first_date = @cur_site.fiscal_first_date(@fiscal_year)
    last_date = @cur_site.fiscal_last_date(@fiscal_year)
    @items = @model.site(@cur_site).in(user_id: @users.pluck(:id)).
      and([
        { :date.gte => first_date },
        { :date.lte => last_date }
      ])
    @items.each do |item|
      @time_cards[item.user_id] ||= {}
      @time_cards[item.user_id][item.date.month] = item
    end
  end

  def show
    raise "403" unless Gws::Gkan::Manage::Attendance.allowed?(:use, @cur_user, site: @cur_site)
    @hide_workflow_request = true
    render
  end

  def delete
    raise "403" unless Gws::Gkan::Manage::Attendance.allowed?(:use, @cur_user, site: @cur_site)
    render
  end

  def destroy
    raise "403" unless Gws::Gkan::Manage::Attendance.allowed?(:use, @cur_user, site: @cur_site)
    render_destroy @item.destroy, location: { action: :index }, render: :delete
  end

  ##

  def time
    @model = Gws::Gkan::Attendance::TimeEdit
    @type = params[:type]
    raise "404" if !@model::WELL_KNOWN_TYPES.include?(@type)

    if request.get? || request.head?
      @cell = @model.new
      @cell.type = @type
      render template: 'time', layout: false
      return
    end
    @cell = @model.new params.require(:cell).permit(@model.permitted_fields)
    @cell.cur_site = @cur_site
    @cell.cur_user = @cur_user
    @cell.type = @type

    result = false
    if @cell.valid?
      time = @cell.calc_time(@cur_date)
      @item.histories.create(
        date: @cur_date, field_name: @type, action: 'modify',
        time: time, reason: @cell.in_reason
      )
      @record.send("#{@type}=", time)
      result = @record.save
    end

    if result
      location = crud_redirect_url || { action: :index }
      location = url_for(location) if location.is_a?(Hash)
      notice = t('ss.notice.saved')

      respond_to do |format|
        flash[:notice] = notice
        format.html do
          if request.xhr?
            render json: { location: location }, status: :ok, content_type: json_content_type
          else
            redirect_to location
          end
        end
        format.json { render json: { location: location }, status: :ok, content_type: json_content_type }
      end
    else
      respond_to do |format|
        format.html { render template: 'time', layout: false, status: :unprocessable_entity }
        format.json { render json: @cell.errors.full_messages, status: :unprocessable_entity, content_type: json_content_type }
      end
    end
  end

  def memo
    if request.get? || request.head?
      render template: 'memo', layout: false
      return
    end

    safe_params = params.require(:record).permit(:memo)
    @record.memo = safe_params[:memo]

    location = crud_redirect_url || { action: :index }
    if @record.save
      notice = t('ss.notice.saved')
    else
      notice = @record.errors.full_messages.join("\n")
    end
    redirect_to location, notice: notice
  end

  def travel_cost
    if request.get? || request.head?
      render template: 'travel_cost', layout: false
      return
    end

    safe_params = params.require(:record).permit(:travel_cost)
    travel_cost = safe_params[:travel_cost]
    @record.travel_cost = travel_cost.present? ? travel_cost.to_i : nil

    location = crud_redirect_url || { action: :index }
    if @record.save
      @item.update_total_cost
      notice = t('ss.notice.saved')
    else
      notice = @record.errors.full_messages.join("\n")
    end
    redirect_to location, notice: notice
  end

  def location
    @locations = Gws::Gkan::Attendance::Location.site(@cur_site).user(@cur_user).to_a
    @location = @locations.find { |item| item.name == @record.location }
    @record.location_id = @location.id if @location

    if request.get? || request.head?
      render template: 'location', layout: false
      return
    end

    safe_params = params.require(:record).permit(:location_id)
    location = @locations.find { |item| item.id == safe_params[:location_id].to_i }

    if location
      @record.location = location.name
      @record.location_cost = location.location_cost.to_i
    else
      @record.location = nil
    end

    location = crud_redirect_url || { action: :index }
    if @record.save
      @item.update_total_cost
      notice = t('ss.notice.saved')
    else
      notice = @record.errors.full_messages.join("\n")
    end
    redirect_to location, notice: notice
  end

  def night_shift
    if request.get? || request.head?
      render template: 'night_shift', layout: false
      return
    end

    safe_params = params.require(:record).permit(:night_shift)
    @record.night_shift = safe_params[:night_shift]

    location = crud_redirect_url || { action: :index }
    if @record.save
      notice = t('ss.notice.saved')
    else
      notice = @record.errors.full_messages.join("\n")
    end
    redirect_to location, notice: notice
  end

  def overtime_files
    @model = Gws::Gkan::Attendance::OvertimeFileEdit
    @cell = @model.new
    @cell.items = @overtime_files[@cur_date].to_a

    if request.get? || request.head?
      render template: 'overtime_files', layout: false
      return
    end

    @cell.in_items = params.permit(@model.permitted_fields).require(:in_items)
    result = @cell.save

    if result
      location = crud_redirect_url || { action: :index }
      location = url_for(location) if location.is_a?(Hash)
      notice = t('ss.notice.saved')

      respond_to do |format|
        flash[:notice] = notice
        format.html do
          if request.xhr?
            render json: { location: location }, status: :ok, content_type: json_content_type
          else
            redirect_to location
          end
        end
        format.json { render json: { location: location }, status: :ok, content_type: json_content_type }
      end
    else
      respond_to do |format|
        format.html { render template: 'overtime_files', layout: false, status: :unprocessable_entity }
        format.json { render json: @cell.errors.full_messages, status: :unprocessable_entity, content_type: json_content_type }
      end
    end
  end

  def leave_files
    @items = @leave_files[@cur_date].to_a
    render template: 'leave_files', layout: false
  end

  def detail
    render template: 'detail', layout: false
  end
end
