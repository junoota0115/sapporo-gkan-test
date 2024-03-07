class Gws::Gkan::Attendance::TimeEdit
  extend SS::Translation
  include ActiveModel::Model
  include SS::PermitParams

  WELL_KNOWN_TYPES = %w(start enter close leave break_time)
  REQUIRED_REASON_TYPES = %w(start enter close leave)
  DAY_TYPES = %w(today tomorrow)

  attr_accessor :cur_site, :cur_user, :type,
    :in_day, :in_hour, :in_minute, :in_reason

  permit_params :in_day, :in_hour, :in_minute, :in_reason

  validates :type, inclusion: { in: WELL_KNOWN_TYPES }
  validates :in_day, inclusion: { in: DAY_TYPES, allow_blank: true }
  # validates :in_hour, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 24, allow_blank: true }
  validates :in_hour, numericality: { only_integer: true, allow_blank: true }
  validates :in_minute, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 60, allow_blank: true }
  validates :in_reason, presence: true, if: ->{ reason_required? }

  def reason_required?
    REQUIRED_REASON_TYPES.include?(type)
  end

  def calc_time(date)
    if in_hour.blank? || in_minute.blank?
      return nil
    elsif in_day == "tomorrow"
      date.tomorrow.beginning_of_day + Integer(in_hour).hours + Integer(in_minute).minutes
    else
      date.beginning_of_day + Integer(in_hour).hours + Integer(in_minute).minutes
    end
  end

  private

  class << self
    def t(*args)
      human_attribute_name(*args)
    end
  end
end
