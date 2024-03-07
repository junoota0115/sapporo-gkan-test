class Gws::Gkan::Leave
  include SS::Document
  include Gws::Referenceable
  include Gws::Reference::User
  include Gws::Reference::Site
  include Gws::SitePermission

  set_permission_name "gws_gkan_admin_settings", :use

  seqid :id
  field :name, type: String
  field :code, type: String
  field :leave_type, type: String
  field :remark, type: String
  field :order, type: Integer

  permit_params :name, :code, :leave_type, :remark, :order

  validates :name, presence: true, length: { maximum: 80 }
  validates :code, presence: true, length: { maximum: 80 }
  validates :leave_type, presence: true
  validates :remark, length: { maximum: 400 }

  def leave_type_options
    I18n.t("gws/gkan.options.leave_type").map { |k, v| [v, k] }
  end

  def annual_leave?
    leave_type == "annual_leave"
  end

  default_scope -> { order_by(order: 1, name: 1) }

  def long_name
    "[#{code}] #{name}"
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
