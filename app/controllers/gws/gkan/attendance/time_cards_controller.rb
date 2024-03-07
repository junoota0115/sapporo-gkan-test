class Gws::Gkan::Attendance::TimeCardsController < ApplicationController
  include Gws::BaseFilter
  include Gws::CrudFilter
  include Gws::Gkan::AttendanceFilter
  include Gws::Attendance::TimeCardFilter

  model Gws::Gkan::Attendance::TimeCard

  append_view_path "app/views/gws/gkan/attendance/time_cards/form"

  before_action :set_active_year_range
  before_action :set_cur_month
  before_action :set_items
  #before_action :create_new_time_card_if_necessary, only: %i[index]
  before_action :set_item
  before_action :set_record, only: %i[time detail memo travel_cost location night_shift overtime_files leave_files]
  before_action :set_overtime_files, only: [:index, :overtime_files, :download, :print], if: -> { @item }
  before_action :set_leave_files, only: [:index, :leave_files, :download, :print], if: -> { @item }

  helper_method :year_month_options
  helper_method :render_over_time

  navi_view "gws/gkan/attendance/main/navi"

  private

  def set_crumbs
    @crumbs << [@cur_site.menu_gkan_attendance_label || t('modules.gws/gkan/attendance'), gws_gkan_attendance_main_path]
    @crumbs << [ t("modules.gws/gkan/attendance/time_card"), { action: :index } ]
  end

  def fix_params
    { cur_user: @cur_user, cur_site: @cur_site }
  end

  def set_items
    @items ||= @model.site(@cur_site).
      user(@cur_user).
      allow(:use, @cur_user, site: @cur_site).
      where(:date.gte => @active_year_range.first).
      search(params[:s])
  end

  def create_new_time_card_if_necessary
    @item = @items.where(date: @cur_month).first
    if @item.blank? && Time.zone.now.year == @cur_month.year && Time.zone.now.month == @cur_month.month
      @item = @model.new fix_params
      @item.date = @cur_month
      @item.duty_setting = @cur_duty
      @item.save!
    end
  end

  def set_item
    create_new_time_card_if_necessary

    # タイムカードの「本日」は日替わり線（深夜3時）を考慮しない
    @today = Time.zone.now.beginning_of_day
    @today_time_card = Gws::Gkan::Attendance::TimeCard.site(@cur_site).user(@cur_user).where(date: @today.beginning_of_month).first
    @today_record = @today_time_card ? @today_time_card.records.where(date: @today).first : nil
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

  def year_month_options
    @items.pluck(:date).map(&:in_time_zone).sort { |lhs, rhs| rhs <=> lhs }.map do |date|
      [ I18n.l(date.to_date, format: :attendance_year_month), "#{date.year}#{format('%02d', date.month)}" ]
    end
  end

  def hour_options
    (0..23).map do |h|
      [ I18n.t('gws/attendance.hour', count: h), h.to_s ]
    end
  end

  def minute_options
    60.times.to_a.map { |m| [ I18n.t('gws/attendance.minute', count: m), m ] }
  end

  def crud_redirect_url
    ref = params[:ref]
    if ref.present? && trusted_url?(ref)
      ref = ::Addressable::URI.parse(ref)
      return ref.request_uri
    end
    super
  end

  public

  def index
    # Gws::Memo::Notifier.deliver!(
    #   cur_site: @cur_site,
    #   cur_group: @cur_group, 
    #   cur_user: @cur_user,
    #   to_users: [@cur_user], 
    #   item: @item, 
    #   subject: 'timecard', 
    #   text: 'fuga'
    # )
  end

  ##

  def enter
    raise '403' if !@model.allowed?(:use, @cur_user, site: @cur_site)

    location = params[:ref].presence || { action: :index }
    if @item.locked?
      redirect_to(location, { notice: t('gws/attendance.already_locked') })
      return
    end

    render_opts = { location: location, render: { template: "index" }, notice: t('gws/attendance.notice.punched') }
    render_update @item.punch("#{params[:action]}#{params[:index]}"), render_opts
  end
  alias leave enter

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

  def download
    if request.get? || request.head?
      return
    end

    safe_params = params.require(:item).permit(:encoding)
    encoding = safe_params[:encoding]

    @downloader = Gws::Gkan::Attendance::TimeCard::Downloader.new
    @downloader.cur_site = @cur_site
    @downloader.cur_user = @cur_user
    @downloader.item = @item
    @downloader.encoding = encoding

    filename = "time_cards_#{Time.zone.now.to_i}.csv"
    send_enum(@downloader.enum_csv, type: "text/csv; charset=#{encoding}", filename: filename)
  end

  def print
    render template: 'print', layout: 'ss/print'
  end
end
