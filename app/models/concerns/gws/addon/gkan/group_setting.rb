module Gws::Addon::Gkan::GroupSetting
  extend ActiveSupport::Concern
  extend SS::Addon

  set_addon_type :organization

  def attendance_management_year
    3
  end

  def attendance_time_changed_hour
    5
  end

  def attendance_time_changed_minute
    attendance_time_changed_hour * 60
  end

  def attendance_year_changed_month
    fiscal_year_changed_month
  end

  def calc_attendance_date(time = Time.zone.now)
    Time.zone.at(time.to_i - attendance_time_changed_minute * 60).beginning_of_day
  end
end
