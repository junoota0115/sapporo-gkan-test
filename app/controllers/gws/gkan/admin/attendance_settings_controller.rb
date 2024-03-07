class Gws::Gkan::Admin::AttendanceSettingsController < ApplicationController
  include Gws::BaseFilter
  include Gws::CrudFilter

  model Gws::Gkan::AttendanceSetting

  navi_view "gws/gkan/admin/main/navi"

  before_action :set_user

  helper_method :duty_setting_options
  helper_method :leave_setting_options

  private

  def set_crumbs
    set_user
    @crumbs << [ @cur_site.menu_gkan_attendance_label || t('modules.gws/gkan/attendance'), gws_gkan_attendance_main_path ]
    @crumbs << [ t('modules.gws/gkan/admin/attendance_setting'), gws_gkan_admin_users_path ]
    @crumbs << [ @user.name, action: :index ]
  end

  def set_user
    @user ||= Gws::User.find(params[:user_id])
    raise "404" unless @user
  end

  def fix_params
    { cur_user: @user, cur_site: @cur_site }
  end

  def duty_setting_options
    Gws::Gkan::DutySetting.site(@cur_site).map { |item| [item.long_name, item.id] }
  end

  def leave_setting_options
    Gws::Gkan::LeaveSetting.site(@cur_site).map { |item| [item.name, item.id] }
  end

  public

  def index
    @items = @model.site(@cur_site).user(@user)
    @attendance = @model.current_setting(@cur_site, @user, Time.zone.now)
  end
end
