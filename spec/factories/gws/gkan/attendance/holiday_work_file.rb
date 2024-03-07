FactoryBot.define do
  factory :gws_gkan_attendance_holiday_work_file, class: Gws::Gkan::Attendance::HolidayWorkFile do
    cur_site { gkan_site }
    cur_user { gkan_user("101") }
    duty_setting do
      Gws::Gkan::AttendanceSetting.current_setting(gkan_site, gkan_user("101"), Time.zone.now).duty_setting
    end

    in_date { Time.zone.today.to_s }
    in_start_hour { 8 }
    in_start_minute { 30 }
    in_close_hour { 17 }
    in_close_minute { 15 }

    expense { "compensate" }
    comp_date { Time.zone.today.advance(days: 3) }

    name { unique_id }
    body { unique_id }
  end
end
