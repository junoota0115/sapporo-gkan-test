class Gws::Gkan::LeaveUnit
  include SS::Document
  include Gws::Referenceable
  include Gws::SitePermission

  set_permission_name "gws_gkan_admin_settings", :use

  seqid :id
  field :name, type: String
  belongs_to :setting, class_name: "Gws::Gkan::LeaveSetting"
  belongs_to :leave, class_name: "Gws::Gkan::Leave"
  field :paid_type, type: String
  field :effective_count, type: Integer
  field :effective_unit, type: String
  field :order, type: Integer

  permit_params :leave_id, :paid_type, :effective_count, :effective_unit, :order

  validates :leave_id, presence: true
  #validates :paid_type, presence: true
  #validates :effective_count, presence: true
  #validates :effective_unit, presence: true
  before_save :set_name

  default_scope -> { order_by(order: 1) }

  def paid_type_options
    I18n.t("gws/gkan.options.paid_type").map { |k, v| [v, k] }
  end

  def annual_leave?
    leave.leave_type == "annual_leave"
  end

  private

  def paid?
    paid_type == "paid"
  end

  def unpaid?
    paid_type == "unpaid"
  end

  def set_name
    self.name = "[#{leave.code}] #{leave.name} / #{label(:paid_type)}"
  end

  public

  def effective_unit_options
    I18n.t("gws/gkan.options.effective_unit").map { |k, v| [v, k] }
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
