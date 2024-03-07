class Workflow::Route
  include Workflow::Model::Route
  include Workflow::Addon::ApproverView
  include Workflow::Addon::CirculationView
  include Cms::SitePermission

  set_permission_name 'workflow_routes', :use

  attr_accessor :cur_site

  class << self
    def site(site)
      user_ids = Cms::User.site(site).pluck(:id)
      self.in(user_id: user_ids)
    end
  end
end
