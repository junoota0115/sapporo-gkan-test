class Gws::Gkan::Admin::DutySettingsController < ApplicationController
  include Gws::BaseFilter
  include Gws::CrudFilter

  model Gws::Gkan::DutySetting

  navi_view "gws/gkan/admin/main/navi"

  helper_method :format_minutes

  private

  def set_crumbs
    @crumbs << [ @cur_site.menu_gkan_attendance_label || t('modules.gws/gkan/attendance'), gws_gkan_attendance_main_path ]
    @crumbs << [ t('modules.gws/gkan/admin/duty_setting'), action: :index ]
  end

  def fix_params
    { cur_user: @cur_user, cur_site: @cur_site }
  end

  def format_minutes(minutes)
    (minutes.to_i > 0) ? "#{minutes / 60}:#{format("%02d", (minutes % 60))}" : "--:--"
  end

  public

  def index
    @items = @model.site(@cur_site).
      allow(:read, @cur_user, site: @cur_site).
      search(params[:s])
  end
end
