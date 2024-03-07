class Gws::Gkan::Manage::Work::WorkTimesController < ApplicationController
  include Gws::BaseFilter
  include Gws::CrudFilter

  model Gws::Gkan::Manage::Work::SearchWorkTime

  navi_view "gws/gkan/manage/work/main/navi"

  helper_method :fiscal_year_options
  helper_method :months

  before_action :set_active_year_range
  before_action :set_fiscal_year

  private

  def set_crumbs
    @crumbs << [ @cur_site.menu_gkan_attendance_label || t('modules.gws/gkan/attendance'), gws_gkan_attendance_main_path ]
    @crumbs << [ t('modules.gws/gkan/manage/work'), gws_gkan_manage_work_main_path ]
    @crumbs << [ t('modules.gws/gkan/manage/work/work_times'), { action: :index } ]
  end

  def fix_params
    { cur_user: @cur_user, cur_site: @cur_site, fiscal_year: @fiscal_year }
  end

  def fiscal_year_options
    @active_year_range.map { |y| ["#{y}#{I18n.t("ss.fiscal_year")}", y] }.reverse
  end

  def months
    @cur_site.fiscal_months
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

  public

  def index
    if params[:item]
      @item = @model.new get_params
    else
      @item = @model.new fix_params
    end
    if @item.group.nil?
      @item.group_id = @cur_group.try(:id) || @cur_site.id
    end
    raise "403" unless @item.allowed?(:use, @cur_user, site: @cur_site)

    @group = @item.group
    @items = @group.users.active.order_by_title(@cur_site)
  end
end
