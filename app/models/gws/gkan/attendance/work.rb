module Gws::Gkan
  module Attendance
    module Work
      extend Gws::ModulePermission

      set_permission_name :gws_gkan_attendance_work_days, :use
    end
  end
end
