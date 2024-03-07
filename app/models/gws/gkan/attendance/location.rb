class Gws::Gkan::Attendance::Location
  include SS::Document
  include Gws::Referenceable
  include Gws::Reference::User
  include Gws::Reference::Site
  include Gws::SitePermission

  set_permission_name "gws_gkan_attendance_locations", :use

  seqid :id
  field :name, type: String
  field :location_cost, type: Integer
  field :order, type: Integer

  permit_params :name, :location_cost, :order

  validates :name, presence: true, length: { maximum: 80 }
  validates :location_cost, numericality: { greater_than_or_equal_to: 0 }

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
