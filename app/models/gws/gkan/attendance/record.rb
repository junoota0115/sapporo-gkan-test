class Gws::Gkan::Attendance::Record
  extend SS::Translation
  include SS::Document

  embedded_in :time_card, class_name: 'Gws::Gkan::Attendance::TimeCard'

  cattr_accessor(:punchable_field_names)

  self.punchable_field_names = %w(enter leave)

  attr_accessor :etc_travel_cost, :location_id

  ##
  field :date, type: DateTime
  field :enter, type: DateTime # 出勤打刻
  field :leave, type: DateTime # 退勤打刻
  field :break_time, type: DateTime # 休憩時間
  field :memo, type: String # 備考
  field :location, type: String # 勤務地名
  field :location_cost, type: Integer # 通勤手当
  field :travel_cost, type: Integer # 実費交通費
  field :night_shift, type: String, default: "disabled" # 宿直
  ##
  field :start, type: DateTime # 開始予定時刻
  field :close, type: DateTime # 終業予定時刻
  ##
  field :regular_start, type: DateTime # 所定開始時刻
  field :regular_close, type: DateTime # 所定終業時刻
  field :regular_holiday, type: String, default: "workday" # 所定休日
  ##
  field :break_minutes, type: Integer # 休憩時間(分)
  field :date_minutes, type: Integer # 就業予定時間(分)
  field :work_minutes, type: Integer # 執務時間(分)
  field :over_minutes, type: Integer # 時間外時間(分)

  self.punchable_field_names = self.punchable_field_names.freeze

  validates :date, presence: true
  #validate :validate_start_close

  before_save :set_break_minutes
  before_save :set_date_minutes
  before_save :set_work_minutes
  before_save :set_over_minutes

  #def validate_start_close
  #  if start && close && start >= close
  #    errors.add :close, :greater_than, count: t(:start)
  #  end
  #  if regular_start && regular_close && regular_start >= regular_close
  #    errors.add :regular_close, :greater_than, count: t(:regular_start)
  #  end
  #end

  def find_latest_history(field_name)
    criteria = time_card.histories.where(date: date.in_time_zone('UTC'), field_name: field_name)
    criteria.order_by(created: -1).first
  end

  def date_range
    changed_minute = time_card.site.attendance_time_changed_minute
    hour, min = changed_minute.divmod(60)

    lower_bound = date.in_time_zone.change(hour: hour, min: min, sec: 0)
    upper_bound = lower_bound + 1.day

    # lower_bound から upper_bound。ただし upper_bound は範囲に含まない。
    lower_bound...upper_bound
  end

  def time_to_min(time)
    time.hour * 60 + time.min
  end

  def min_to_time(date, min)
    hour = min / 60
    min = min % 60
    date.change(hour: hour, min: min)
  end

  def work_time
    return nil if work_minutes.nil?
    min_to_time(date, work_minutes)
  end

  def over_time
    return nil if over_minutes.nil?
    min_to_time(date, over_minutes)
  end

  def set_break_minutes
    if break_time
      self.break_minutes = time_to_min(break_time)
    else
      self.break_minutes = nil
    end
  end

  def set_date_minutes
    if start && close
      self.date_minutes = time_to_min(close) - time_to_min(start)
    else
      self.date_minutes = nil
    end
  end

  def set_work_minutes
    if enter && leave && regular_start && regular_close && break_time
      effective_start = (start > regular_start) ? start : regular_start
      self.work_minutes = time_to_min(leave) - time_to_min(effective_start) - time_to_min(break_time)
      self.work_minutes = 0 if work_minutes < 0
    else
      self.work_minutes = nil
    end
  end

  def set_over_minutes
    if date_minutes && work_minutes
      self.over_minutes = time_to_min(leave) - time_to_min(regular_close)
      self.over_minutes = 0 if over_minutes < 0
    else
      self.over_minutes = nil
    end
  end

  def night_shift_options
    I18n.t("gws/gkan.options.night_shift").map { |k, v| [v, k] }
  end

  def regular_holiday_options
    I18n.t("gws/gkan.options.regular_holiday").map { |k, v| [v, k] }
  end

  def night_shift_enabled?
    night_shift == "enabled"
  end

  def regular_workday?
    !regular_holiday?
  end

  def regular_holiday?
    regular_holiday == "holiday"
  end
end
