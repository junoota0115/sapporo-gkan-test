class Gws::Gkan::Attendance::LocationsController < ApplicationController
  include Gws::BaseFilter
  include Gws::CrudFilter
  include Gws::Gkan::AttendanceFilter

  model Gws::Gkan::Attendance::Location

  navi_view "gws/gkan/attendance/main/navi"

  private

  def set_crumbs
    @crumbs << [ @cur_site.menu_gkan_attendance_label || t('modules.gws/gkan/attendance'), gws_gkan_attendance_main_path ]
    @crumbs << [ t("modules.gws/gkan/attendance/location"), action: :index ]
  end

  def fix_params
    { cur_user: @cur_user, cur_site: @cur_site }
  end

  public

  def index
    @items = @model.site(@cur_site).user(@cur_user).
      allow(:read, @cur_user, site: @cur_site).
      search(params[:s]).to_a
  end
end
