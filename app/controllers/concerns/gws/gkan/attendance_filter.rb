module Gws::Gkan::AttendanceFilter
  extend ActiveSupport::Concern

  included do
    before_action :set_attendance
  end

  private

  def set_attendance
    @cur_attendance = Gws::Gkan::AttendanceSetting.current_setting(@cur_site, @cur_user, Time.zone.now)
    if @cur_attendance.nil?
      @hide_menu_view = true
      @hide_content_navi_view = true
      render template: "gws/gkan/attendance/errors/attendance"
      return
    end

    @cur_duty = @cur_attendance.duty_setting
    @cur_leave = @cur_attendance.leave_setting
  end
end
