class Gws::Gkan::Admin::LeaveUnitsController < ApplicationController
  include Gws::BaseFilter
  include Gws::CrudFilter

  model Gws::Gkan::LeaveUnit

  navi_view "gws/gkan/admin/leave_units/navi"

  before_action :set_leave_setting

  helper_method :leave_options
  helper_method :crud_redirect_url

  private

  def set_crumbs
    set_leave_setting
    @crumbs << [ @cur_site.menu_gkan_attendance_label || t('modules.gws/gkan/attendance'), gws_gkan_attendance_main_path ]
    @crumbs << [ t('modules.gws/gkan/admin/leave_setting'), gws_gkan_admin_leave_settings_path ]
  end

  def fix_params
    { setting: @leave_setting }
  end

  def set_leave_setting
    @leave_setting ||= Gws::Gkan::LeaveSetting.find(params[:leave_setting_id]) rescue nil
    raise "404" unless @leave_setting
  end

  def leave_options
    Gws::Gkan::Leave.site(@cur_site).map { |leave| [leave.long_name, leave.id] }
  end

  def crud_redirect_url
    gws_gkan_admin_leave_setting_path(id: @leave_setting)
  end
end
