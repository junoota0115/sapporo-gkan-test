class Gws::Portal::GroupSetting
  include SS::Document
  include Gws::Referenceable
  include Gws::Reference::User
  include Gws::Reference::Site
  include Gws::Portal::PortalModel
  include Gws::Addon::ReadableSetting
  include Gws::Addon::GroupPermission
  include Gws::Addon::History

  index({ portal_group_id: 1, site_id: 1 }, { unique: true })

  no_needs_read_permission_to_read

  field :name, type: String
  belongs_to :portal_group, class_name: 'Gws::Group', inverse_of: :portal_group_setting
  has_many :portlets, class_name: 'Gws::Portal::GroupPortlet', dependent: :destroy

  permit_params :name

  validates :name, presence: true, length: { maximum: 20 }
  validates :portal_group_id, presence: true, uniqueness: { scope: :site_id }

  def portlet_models
    %w(
      free links schedule bookmark report workflow circular monitor
      board faq qna share notice presence survey ad
    ).map do |key|
      Gws::Portal::GroupPortlet.portlet_model(key)
    end
  end

  def default_portlets(settings = [])
    settings = settings.presence
    settings ||= SS.config.gws['portal']['organization_portlets'].presence if site_id == portal_group_id
    settings ||= SS.config.gws['portal']['group_portlets'].presence
    return [] if settings.blank?

    Gws::Portal::GroupPortlet.default_portlets(settings)
  end
end
