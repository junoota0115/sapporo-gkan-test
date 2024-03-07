class Gws::Gkan::Manage::Work::WorkLimitsController < ApplicationController
  include Gws::BaseFilter
  include Gws::CrudFilter

  model Gws::Gkan::Manage::Work::SearchWorkLimit

  navi_view "gws/gkan/manage/work/main/navi"

  helper_method :fiscal_year_options

  before_action :redirect_with_params
  before_action :set_cur_month
  before_action :set_limit_term
  before_action :set_active_year_range
  before_action :set_fiscal_year

  helper_method :limit_range
  helper_method :limit_term_options
  helper_method :year_month_options

  private

  def set_crumbs
    @crumbs << [ @cur_site.menu_gkan_attendance_label || t('modules.gws/gkan/attendance'), gws_gkan_attendance_main_path ]
    @crumbs << [ t('modules.gws/gkan/manage/work'), gws_gkan_manage_work_main_path ]
    @crumbs << [ t('modules.gws/gkan/manage/work/work_limits'), { action: :index } ]
  end

  def redirect_with_params
    return if params[:year_month] != "-" && params[:limit_term] != "-"

    group_id = params.dig(:item, :group_id)
    today = @cur_site.calc_attendance_date(Time.zone.now)

    options = { action: :index }
    options[:year_month] = today.strftime('%Y%m')
    options[:limit_term] = "1months"
    options[:item] = { group_id: group_id } if group_id
    redirect_to options
  end

  def set_cur_month
    raise "404" if params[:year_month].blank? || params[:year_month].length != 6
    year = params[:year_month][0..3]
    month = params[:year_month][4..5]
    @cur_month = Time.zone.parse("#{year}/#{month}/01")
  end

  def set_limit_term
    limit_term = params[:limit_term].split("months").first.to_i rescue 0
    raise "404" if limit_term < 1 || limit_term > 12
    @limit_term = limit_term
  end

  def fix_params
    { cur_user: @cur_user, cur_site: @cur_site, month: @cur_month, limit_term: @limit_term }
  end

  def fiscal_year_options
    @active_year_range.map { |y| ["#{y}#{I18n.t("ss.fiscal_year")}", y] }.reverse
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

  def limit_range
    start = @cur_month.advance(months: -11)
    0.upto(11).map { |i| start.advance(months: i) }
  end

  def year_month_options
    options = []
    @active_year_range.each do |year|
      (1..12).each do |month|
        options << ["#{year}年#{month}月", "#{year}#{format('%02d', month)}"]
      end
    end
    options
  end

  def limit_term_options
    I18n.t("gws/gkan.options.limit_term").map { |k, v| [v, k] }
  end

  public

  def index
    if params[:item]
      @item = @model.new get_params
    else
      @item = @model.new fix_params
    end
    raise "403" unless @item.allowed?(:use, @cur_user, site: @cur_site)

    if @item.users.present?
      @items = @item.users.active.order_by_title(@cur_site)
    else
      if @item.group.nil?
        @item.group_id = @cur_group.try(:id) || @cur_site.id
      end
      @group = @item.group
      @items = @group.users.active.order_by_title(@cur_site)
    end
  end
end
