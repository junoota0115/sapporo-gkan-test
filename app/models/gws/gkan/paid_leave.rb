class Gws::Gkan::PaidLeave
  include SS::Document
  include Gws::Referenceable
  include Gws::Reference::User
  include Gws::Reference::Site
  include Gws::SitePermission

  set_permission_name "gws_gkan_attendance_time_cards", :use

  seqid :id
  field :name, type: String
  field :hour_type, type: String
  field :start_date, type: DateTime
  field :close_date, type: DateTime
  field :effective_days, type: Integer
  field :remark, type: String
  belongs_to :setting, class_name: "Gws::Gkan::AttendanceSetting"

  permit_params :hour_type, :start_date, :effective_days, :remark

  validates :setting_id, presence: true
  validates :hour_type, presence: true
  validates :start_date, presence: true
  validates :effective_days, presence: true
  validates :remark, length: { maximum: 400 }

  before_save :set_close_date
  before_save :set_name

  default_scope -> { order_by(start_date: 1) }

  def hour_type_options
   I18n.t("gws/gkan.options.hour_type").map { |k, v| [v, k] }
  end

  private

  def set_close_date
    year = site.fiscal_year(start_date)
    self.close_date = site.fiscal_first_date(year + 1)
  end

  def set_name
    self.name = "#{start_date.strftime("%Y/%m/%d")}#{I18n.t("ss.wave_dash")}#{close_date.strftime("%Y/%m/%d")}"
    self.name += " "
    self.name += "#{effective_days}#{I18n.t("datetime.prompts.day")}"
  end

  class << self
    def index_by_hours
      items = {}
      self.all.to_a.each do |item|
        items[item.hour_type] ||= []
        items[item.hour_type] << item
      end
      items
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
