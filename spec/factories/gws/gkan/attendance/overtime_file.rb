FactoryBot.define do
  factory :gws_gkan_attendance_overtime_file, class: Gws::Gkan::Attendance::OvertimeFile do
    cur_site { gkan_site }
    cur_user { gkan_user("101") }
    duty_setting do
      Gws::Gkan::AttendanceSetting.current_setting(gkan_site, gkan_user("101"), Time.zone.now).duty_setting
    end

    in_date { Time.zone.today.to_s }
    in_start_hour { 17 }
    in_start_minute { 15 }
    in_close_hour { 20 }
    in_close_minute { 30 }

    name { unique_id }
    body { unique_id }
  end
end
