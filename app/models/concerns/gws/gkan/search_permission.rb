module Gws::Gkan::SearchPermission
  extend ActiveSupport::Concern
  include SS::Permission

  def allowed?(action, user, opts = {})
    user = user.gws_user
    site = opts[:site] || @cur_site
    node = opts[:node] || @cur_node
    owned = opts[:owned] || true

    action = permission_action || action

    permits = ["#{action}_other_#{self.class.permission_name}"]
    permits << "#{action}_private_#{self.class.permission_name}" if owned

    user.gws_role_permit_any?(site, permits)
  end
end
