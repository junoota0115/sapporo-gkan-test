class Gws::Gkan::Attendance::LeaveFile
  include SS::Document
  include Gws::Referenceable
  include Gws::Reference::User
  include Gws::Reference::Site
  include Gws::Addon::Gkan::Approver
  include Gws::Addon::File
  include Gws::Addon::GroupPermission
  include Gws::Addon::History

  #permission_include_sub_groups

  attr_accessor :in_date, :in_start_hour, :in_start_minute,
    :in_close_hour, :in_close_minute,
    :in_start_date, :in_close_date

  seqid :id
  field :name, type: String
  field :long_name, type: String
  field :body, type: String
  belongs_to :duty_setting, class_name: "Gws::Gkan::DutySetting"
  belongs_to :leave_unit, class_name: "Gws::Gkan::LeaveUnit"

  ##
  field :date, type: DateTime
  field :start_at, type: DateTime
  field :close_at, type: DateTime
  field :allday, type: String

  permit_params :name, :leave_unit_id, :body,
    :in_date, :in_start_hour, :in_start_minute, :in_close_hour, :in_close_minute,
    :allday, :in_start_date, :in_close_date

  before_validation :set_start_close
  validates :name, presence: true, length: { maximum: 80 }
  validates :duty_setting_id, presence: true
  validates :leave_unit_id, presence: true
  validate :validate_start_close
  before_save :set_long_name

  def private_show_path
    url_helper = Rails.application.routes.url_helpers
    url_helper.gws_gkan_attendance_leave_file_path(site: site, id: id)
  end

  def workflow_wizard_path
    url_helper = Rails.application.routes.url_helpers
    url_helper.gws_gkan_attendance_leave_wizard_path(site: site.id, id: id)
  end

  def workflow_pages_path
    url_helper = Rails.application.routes.url_helpers
    url_helper.gws_gkan_attendance_leave_file_path(site: site.id, id: id)
  end

  def allday?
    allday == "allday"
  end

  def allday_options
    [[I18n.t("gws/schedule.options.allday.allday"), "allday"]]
  end

  def hour_options
    (0..23).map { |h| [ I18n.t("gws/attendance.hour", count: h), h ] }
  end

  def minute_options
    60.times.to_a.map { |m| [ I18n.t('gws/attendance.minute', count: m), m ] }
  end

  def start_close_label
    start_date = I18n.l(start_at.to_date, format: :long)
    close_date = I18n.l(close_at.to_date, format: :long)
    start_time = "#{start_at.hour}:#{format('%02d', start_at.minute)}"
    close_time = "#{close_at.hour}:#{format('%02d', close_at.minute)}"
    if allday?
      "#{start_date}#{I18n.t("ss.wave_dash")}#{close_date}"
    else
      "#{start_date} #{start_time}#{I18n.t("ss.wave_dash")}#{close_time}"
    end
  end

  def load_in_minutes
    return if start_at.nil? && close_at.nil?

    if allday?
      self.in_start_date ||= start_at.to_date
      self.in_close_date ||= close_at.to_date
    else
      self.in_date ||= start_at.to_date
      self.in_start_hour ||= start_at.hour
      self.in_start_minute ||= start_at.min
      self.in_close_hour ||= (start_at.to_date == close_at.to_date) ? close_at.hour : close_at.hour + 24
      self.in_close_minute ||= close_at.min
    end
  end

  alias in_start_hour_options hour_options
  alias in_start_minute_options minute_options
  alias in_close_hour_options hour_options
  alias in_close_minute_options minute_options

  private

  def set_long_name
    self.long_name = "#{name}（#{start_close_label}）"
  end

  def set_start_close
    if allday?
      if in_start_date
        self.start_at = Time.zone.parse(in_start_date).beginning_of_day rescue nil
        self.date = start_at
      end
      if in_close_date
        self.close_at = Time.zone.parse(in_close_date).end_of_day rescue nil
      end
    else
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
