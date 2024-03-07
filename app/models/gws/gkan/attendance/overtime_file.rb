class Gws::Gkan::Attendance::OvertimeFile
  include SS::Document
  include Gws::Referenceable
  include Gws::Reference::User
  include Gws::Reference::Site
  include Gws::Addon::Gkan::Approver
  include Gws::Addon::GroupPermission
  include Gws::Addon::History

  #permission_include_sub_groups

  attr_accessor :in_date, :in_start_hour, :in_start_minute,
    :in_close_hour, :in_close_minute

  seqid :id
  field :name, type: String
  field :long_name, type: String
  field :date, type: DateTime
  field :start_at, type: DateTime
  field :close_at, type: DateTime
  field :body, type: String
  belongs_to :duty_setting, class_name: "Gws::Gkan::DutySetting"

  field :over_minutes, type: Integer
  field :day_minutes, type: Integer
  field :night_minutes, type: Integer

  permit_params :name, :body,
    :in_date, :in_start_hour, :in_start_minute,
    :in_close_hour, :in_close_minute

  before_validation :set_start_close
  validates :name, presence: true, length: { maximum: 80 }
  validate :validate_start_close
  before_save :set_long_name
  before_save :set_day_results

  default_scope -> { order_by updated: -1 }

  def hour_options
    (0..47).map do |h|
      tommorow = nil
      label = h

      if h > 23
        tommorow = "翌"
        label -= 24
      end
      [ "#{tommorow}#{I18n.t("gws/attendance.hour", count: label)}", h ]
    end
  end

  def minute_options
    # 60.times.to_a.map { |m| [ I18n.t('gws/attendance.minute', count: m), m ] }
    [0, 15, 30, 45].map { |m| [I18n.t("gws/attendance.minute", count: m), m] }
  end

  alias in_start_hour_options hour_options
  alias in_start_minute_options minute_options
  alias in_close_hour_options hour_options
  alias in_close_minute_options minute_options

  def private_show_path
    url_helper = Rails.application.routes.url_helpers
    url_helper.gws_gkan_attendance_overtime_file_path(site: site, id: id)
  end

  def workflow_wizard_path
    url_helper = Rails.application.routes.url_helpers
    url_helper.gws_gkan_attendance_overtime_wizard_path(site: site.id, id: id)
  end

  def workflow_pages_path
    url_helper = Rails.application.routes.url_helpers
    url_helper.gws_gkan_attendance_overtime_file_path(site: site.id, id: id)
  end

  def start_close_label
    start_date = I18n.l(start_at.to_date, format: :long)
    close_date = I18n.l(close_at.to_date, format: :long)
    start_time = "#{start_at.hour}:#{format('%02d', start_at.minute)}"
    close_time = "#{close_at.hour}:#{format('%02d', close_at.minute)}"
    next_day = (start_date != close_date) ? "翌" : ""
    "#{start_date} #{start_time}#{I18n.t("ss.wave_dash")}#{next_day}#{close_time}"
  end

  def load_in_minutes
    return if start_at.nil? && close_at.nil?

    self.in_date ||= start_at.to_date
    self.in_start_hour ||= start_at.hour
    self.in_start_minute ||= start_at.min
    self.in_close_hour ||= (start_at.to_date == close_at.to_date) ? close_at.hour : close_at.hour + 24
    self.in_close_minute ||= close_at.min
  end

  private

  def set_long_name
    self.long_name = "#{name}（#{start_close_label}）"
  end

  def set_start_close
    self.in_date = Time.zone.parse(in_date).beginning_of_day rescue nil
    return if in_date.nil?

    if in_start_hour && in_start_minute
      self.start_at = in_date.advance(hours: in_start_hour.to_i, minutes: in_start_minute.to_i, sec: 0) rescue nil
      self.date = in_date
    end
    if in_close_hour && in_close_minute
      self.close_at = in_date.advance(hours: in_close_hour.to_i, minutes: in_close_minute.to_i, sec: 0) rescue nil
    end
  end

  def set_day_results
    night_duty_start_at = date.change(hour: 22, min: 0, sec: 0)
    night_duty_close_at = date.advance(days: 1).change(hour: 5, min: 0, sec: 0)
    self.day_minutes, self.night_minutes = ::Gws::Affair::Utils.time_range_minutes(
      (start_at..close_at),
      (night_duty_start_at..night_duty_close_at))
    self.over_minutes = day_minutes + night_minutes
  end

  def validate_start_close
    errors.add :start_at, :blank if self.start_at.nil?
    errors.add :close_at, :blank if self.close_at.nil?

    if start_at && close_at && start_at >= close_at
      errors.add :close_at, :after_than, time: t(:start_at)
    end
  end

  class << self
    def search(params)
      criteria = self.where({})
      return criteria if params.blank?

      if params[:name].present?
        criteria = criteria.search_text params[:name]
      end
      if params[:keyword].present?
        criteria = criteria.keyword_in params[:keyword], :name
      end
      criteria
    end
  end
end
