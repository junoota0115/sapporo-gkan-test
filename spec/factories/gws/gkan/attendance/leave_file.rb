FactoryBot.define do
  factory :gws_gkan_attendance_leave_file, class: Gws::Gkan::Attendance::LeaveFile do
    cur_site { gkan_site }
    cur_user { gkan_user("101") }
    duty_setting do
      Gws::Gkan::AttendanceSetting.current_setting(gkan_site, gkan_user("101"), Time.zone.now).duty_setting
    end
    leave_unit do
      Gws::Gkan::AttendanceSetting.current_setting(gkan_site, gkan_user("101"), Time.zone.now).leave_setting.units.first
    end

    in_date { Time.zone.today.to_s }
    in_start_hour { 8 }
    in_start_minute { 30 }
    in_close_hour { 17 }
    in_close_minute { 15 }

    name { unique_id }
    body { unique_id }
  end
end
