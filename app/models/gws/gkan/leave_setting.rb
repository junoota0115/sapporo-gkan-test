class Gws::Gkan::LeaveSetting
  include SS::Document
  include Gws::Referenceable
  include Gws::Reference::User
  include Gws::Reference::Site
  include Gws::Addon::Gkan::LeaveSetting::Unit
  include Gws::SitePermission

  set_permission_name "gws_gkan_admin_settings", :use

  seqid :id
  field :name, type: String
  field :remark, type: String
  field :order, type: Integer

  permit_params :name, :remark, :order
  permit_params leave_ids: []

  validates :name, presence: true, length: { maximum: 80 }
  validates :remark, length: { maximum: 400 }

  default_scope -> { order_by(order: 1, name: 1) }

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
