class Gws::Gkan::AttendanceSetting
  include SS::Document
  include Gws::Referenceable
  include Gws::Reference::User
  include Gws::Reference::Site
  include Gws::Addon::Gkan::AttendanceSetting::PaidLeave
  include Gws::SitePermission

  set_permission_name "gws_gkan_admin_settings", :use

  attr_accessor :in_start_year, :in_start_month,
    :in_close_year, :in_close_month

  seqid :id
  field :name, type: String
  field :organization_uid, type: String
  field :start_date, type: DateTime
  field :close_date, type: DateTime
  belongs_to :duty_setting, class_name: "Gws::Gkan::DutySetting"
  belongs_to :leave_setting, class_name: "Gws::Gkan::LeaveSetting"
  belongs_to :manager, class_name: "Gws::User"

  permit_params :manager_id, :duty_setting_id, :leave_setting_id
  permit_params :in_start_year, :in_start_month,
    :in_close_year, :in_close_month

  before_validation :set_in_start_close
  validates :user_id, presence: true
  validates :duty_setting_id, presence: true
  validates :leave_setting_id, presence: true
  validate :validate_start_close
  before_save :set_name
  before_save :set_organization_uid

  default_scope -> { order_by(start_date: -1) }

  def active_years
    (1900..2100)
  end

  def active_months
    (1..12)
  end

  def year_options
    active_years.map { |y| ["#{y}#{I18n.t("datetime.prompts.year")}", y] }
  end

  def month_options
    active_months.map { |m| ["#{m}#{I18n.t("datetime.prompts.month")}", m] }
  end

  def manage_attendances
    self.class.where(manager_id: user_id)
  end

  private

  def set_name
    self.name = I18n.t("gws/gkan.formats.attendace_setting_name",
      duty: duty_setting.name, year: start_date.year, month: start_date.month)
  end

  def set_organization_uid
    self.organization_uid = user.organization_uid
  end

  def set_in_start_close
    if in_start_year && in_start_month
      self.in_start_year = active_years.include?(in_start_year.to_i) ? in_start_year.to_i : nil
      self.in_start_month = active_months.include?(in_start_month.to_i) ? in_start_month.to_i : nil
      self.start_date = DateTime.new(in_start_year, in_start_month).in_time_zone.beginning_of_day rescue nil
    end
    if in_close_year && in_close_month
      self.in_close_year = active_years.include?(in_close_year.to_i) ? in_close_year.to_i : nil
      self.in_close_month = active_months.include?(in_close_month.to_i) ? in_close_month.to_i : nil
      self.close_date = DateTime.new(in_close_year, in_close_month).in_time_zone.end_of_month.beginning_of_day rescue nil
    end
  end

  def validate_start_close
    if start_date.blank?
      errors.add :start_date, :blank
      return
    end
    if start_date && close_date && start_date >= close_date
      errors.add :close_date, :greater_than, count: t(:start_date)
    end
  end

  class << self
    def and_current(date)
      self.all.and([
        { start_date: { "$lte" => date.to_date } },
        { "$or" => [
          { close_date: { "$gte" => date.to_date } },
          { close_date: nil },
        ]}
      ])
    end

    def current_setting(site, user, date)
      self.site(site).user(user).and_current(date).first
    end

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
