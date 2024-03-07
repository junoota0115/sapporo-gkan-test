class Gws::Gkan::Attendance::TimeCard
  extend SS::Translation
  include SS::Document
  include Gws::Reference::Site
  include Gws::Reference::User
  include Gws::Addon::Gkan::Approver
  include Gws::Gkan::TimeCardPermission

  seqid :id
  set_permission_name "gws_gkan_attendance_time_cards"

  field :name, type: String
  field :date, type: DateTime
  field :lock_state, type: String
  field :total_location_cost, type: Integer, default: 0
  field :total_travel_cost, type: Integer, default: 0

  embeds_many :histories, class_name: 'Gws::Gkan::Attendance::History'
  embeds_many :records, class_name: 'Gws::Gkan::Attendance::Record'
  belongs_to :duty_setting, class_name: "Gws::Gkan::DutySetting"

  before_validation :normalize_date
  before_validation :set_name
  before_validation :set_lock_state
  after_create :create_records

  validates :lock_state, inclusion: { in: %w(locked unlocked), allow_blank: true }
  validates :duty_setting_id, presence: true

  def view_type
    duty_setting.regular_timecard? ? "regular" : "parttimer"
  end

  def view_year_month
    "#{date.year}#{format('%02d', date.month)}"
  end

  def punch(field_name, punch_at = Time.zone.now, date = Time.zone.now)
    raise "unable to punch: #{field_name}" if !Gws::Gkan::Attendance::Record.punchable_field_names.include?(field_name)

    date = (@cur_site || site).calc_attendance_date(date)
    record = self.records.where(date: date).first
    if record.blank?
      record = self.records.create(date: date)
    end

    if record.send(field_name).present?
      errors.add :base, :already_punched
      return false
    end

    record.send("#{field_name}=", punch_at)
    self.histories.create(date: date, field_name: field_name, action: 'set', time: punch_at)

    # change gws user's presence
    @cur_user.presence_punch((@cur_site || site), field_name) if @cur_user
    record.save
  end

  def locked?
    lock_state == 'locked'
  end

  def unlocked?
    !locked?
  end

  def update_total_cost
    self.total_location_cost = 0
    self.total_travel_cost = 0
    records.each do |record|
      self.total_location_cost += record.location_cost.to_i
      self.total_travel_cost += record.travel_cost.to_i
    end
    update
  end

  #def private_show_path
  #end

  def workflow_wizard_path
    url_helper = Rails.application.routes.url_helpers
    url_helper.gws_gkan_attendance_time_card_wizard_path(site: site.id, year_month: view_year_month, id: id)
  end

  def workflow_pages_path
    url_helper = Rails.application.routes.url_helpers
    url_helper.gws_gkan_attendance_time_card_file_path(site: site.id, year_month: view_year_month, id: id)
  end

  private

  def normalize_date
    return if self.date.blank?

    if self.date.day != 1
      self.date = date.beginning_of_month
    end
  end

  def set_name
    self.name ||= begin
      month = I18n.l(date.to_date, format: :attendance_year_month)
      I18n.t('gws/attendance.formats.time_card_name', month: month)
    end
  end

  def set_lock_state
    self.lock_state = (workflow_state == WORKFLOW_STATE_APPROVE) ? "locked" : "unlocked"
  end

  def create_records
    (date..date.end_of_month).each do |date|
      record = self.records.find_or_initialize_by(date: date)
      record.regular_holiday = duty_setting.regular_holiday(date)
      if record.regular_workday?
        # 所定時間
        record.regular_start = duty_setting.start_time(date)
        record.regular_close = duty_setting.close_time(date)

        # 予定時間
        record.start = record.regular_start
        record.close = record.regular_close
        record.break_time = date.change(hour: 0, min: 45)
      end
      record.save!
    end
  end

  class << self
    def search(params = {})
      all.search_name(params).search_keyword(params).search_group(params)
    end

    def search_name(params = {})
      return all if params.blank? || params[:name].blank?

      all.search_text(params[:name])
    end

    def search_keyword(params)
      return all if params.blank? || params[:keyword].blank?

      all.keyword_in(params[:keyword], :name)
    end

    def search_group(params)
      return all if params.blank? || params[:group].blank?

      group_ids = Gws::Group.active.in_group(params[:group]).pluck(:id)
      user_ids = Gws::User.active.in(group_ids: group_ids).pluck(:id)
      all.in(user_id: user_ids)
    end

    def in_groups(groups)
      group_ids = []
      groups.each do |group|
        group_ids += Gws::Group.in_group(group).pluck(:id)
      end
      group_ids.uniq!

      users = Gws::User.in(group_ids: group_ids).active
      user_ids = users.pluck(:id)

      all.in(user_id: user_ids)
    end

    def and_unlocked
      all.and('$or' => [{ lock_state: 'unlocked' }, { :lock_state.exists => false }])
    end

    def and_locked
      all.where(lock_state: 'locked')
    end

    def lock_all
      raise "not implemented"
    end

    def unlock_all
      raise "not implemented"
    end

    def enum_csv(site, params)
      raise "not implemented"
    end
  end
end
