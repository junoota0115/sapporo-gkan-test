FactoryBot.define do
  factory :gws_gkan_attendance_location, class: Gws::Gkan::Attendance::Location do
    cur_site { gkan_site }
    cur_user { gkan_user("101") }
    name { unique_id }
    location_cost { 600 }
  end
end
