module Gws::Gkan
  module Admin
    extend Gws::ModulePermission

    set_permission_name :gws_gkan_admin_settings, :use
  end
end
