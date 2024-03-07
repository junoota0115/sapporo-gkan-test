module Gws::Gkan
  module Manage
    module Work
      #extend Gws::ModulePermission
      module_function

      def allowed?(action, user, opts = {})
        user   = user.gws_user
        site   = opts[:site]
        action = :use
        name   = :gws_gkan_manage_works

        permits = ["#{action}_other_#{name}"]
        permits << "#{action}_private_#{name}"

        user.gws_role_permit_any?(site, permits)
      end
    end
  end
end
