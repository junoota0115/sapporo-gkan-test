class Gws::Gkan::Admin::PaidLeaveController < ApplicationController
  include Gws::BaseFilter
  include Gws::CrudFilter

  model Gws::Gkan::PaidLeave

  navi_view "gws/gkan/admin/main/navi"

  before_action :set_user
  before_action :set_attendance_setting

  helper_method :crud_redirect_url

  private

  def set_crumbs
    set_user
    set_attendance_setting
    @crumbs << [ @cur_site.menu_gkan_attendance_label || t('modules.gws/gkan/attendance'), gws_gkan_attendance_main_path ]
    @crumbs << [ t('modules.gws/gkan/admin/attendance_setting'), gws_gkan_admin_users_path ]
    @crumbs << [ @user.name, crud_redirect_url ]
  end

  def set_user
    @user ||= Gws::User.find(params[:user_id])
    raise "404" unless @user
  end

  def fix_params
    { cur_user: @cur_user, cur_site: @cur_site, setting: @attendance_setting }
  end

  def set_attendance_setting
    @attendance_setting ||= Gws::Gkan::AttendanceSetting.find(params[:attendance_setting_id]) rescue nil
    raise "404" unless @attendance_setting
  end

  def crud_redirect_url
    gws_gkan_admin_user_attendance_setting_path(id: @attendance_setting)
  end

  public

  def index
    @items = @attendance_setting.paid_leave
  end
end
