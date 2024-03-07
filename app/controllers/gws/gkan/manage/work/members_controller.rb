class Gws::Gkan::Manage::Work::MembersController < ApplicationController
  include Gws::BaseFilter
  include Gws::CrudFilter
  include Gws::Gkan::AttendanceFilter

  model Gws::Gkan::DutySetting

  navi_view "gws/gkan/manage/work/main/navi"

  private

  def set_crumbs
    @crumbs << [ @cur_site.menu_gkan_attendance_label || t('modules.gws/gkan/attendance'), gws_gkan_attendance_main_path ]
    @crumbs << [ t('modules.gws/gkan/manage/work'), gws_gkan_manage_work_main_path ]
    @crumbs << [ t('modules.gws/gkan/manage/work/members'), { action: :index } ]
  end

  public

  def index
    raise "403" unless Gws::Gkan::Manage::Work.allowed?(:use, @cur_user, site: @cur_site)
    @attendances = @cur_attendance.manage_attendances
  end
end
