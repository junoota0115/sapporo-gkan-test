class Gws::Gkan::Attendance::Work::WorkDaysController < ApplicationController
  include Gws::BaseFilter
  include Gws::CrudFilter
  include Gws::Gkan::AttendanceFilter

  navi_view "gws/gkan/attendance/main/navi"

  helper_method :fiscal_year_options
  helper_method :months

  before_action :set_active_year_range
  before_action :set_fiscal_year

  private

  def set_crumbs
    @crumbs << [ @cur_site.menu_gkan_attendance_label || t('modules.gws/gkan/attendance'), gws_gkan_attendance_main_path ]
    @crumbs << [ t("modules.gws/gkan/attendance/work"), action: :index ]
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

  def months
    @cur_site.fiscal_months
  end

  public

  def index
    raise "403" unless Gws::Gkan::Attendance::Work.allowed?(:use, @cur_user, site: @cur_site)

    @item = @cur_attendance
  end
end
