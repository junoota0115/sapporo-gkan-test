class Gws::Gkan::DutySetting
  include SS::Document
  include Gws::Referenceable
  include Gws::Reference::User
  include Gws::Reference::Site
  include Gws::Addon::Gkan::DutySetting::Worktime
  include Gws::Addon::Gkan::DutySetting::Holiday
  include Gws::SitePermission

  set_permission_name "gws_gkan_admin_settings", :use

  seqid :id
  field :name, type: String
  field :code, type: String
  field :remark, type: String
  field :employee_type, type: String
  field :order, type: Integer

  permit_params :name, :code, :remark, :employee_type, :order

  validates :name, presence: true, length: { maximum: 80 }
  validates :remark, length: { maximum: 400 }
  validates :employee_type, presence: true

  default_scope -> { order_by(order: 1, name: 1) }

  def employee_type_options
    I18n.t("gws/gkan.options.employee_type").map { |k, v| [v, k] }
  end

  def regular_timecard?
    !parttimer_timecard?
  end

  def parttimer_timecard?
    employee_type == "parttimer"
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
