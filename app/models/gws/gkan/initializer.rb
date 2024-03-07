module Gws::Gkan
  class Initializer
    # time_cards
    Gws::Role.permission :use_gws_gkan_attendance_time_cards, module_name: 'gws/gkan'
    Gws::Role.permission :edit_gws_gkan_attendance_time_cards, module_name: 'gws/gkan'
    Gws::Role.permission :manage_gws_gkan_attendance_time_cards, module_name: 'gws/gkan'
    Gws::Role.permission :approve_gws_gkan_attendance_time_cards, module_name: 'gws/gkan'
    Gws::Role.permission :reroute_gws_gkan_attendance_time_cards, module_name: 'gws/gkan'

    # overtime_files
    Gws::Role.permission :read_other_gws_gkan_attendance_overtime_files, module_name: 'gws/gkan'
    Gws::Role.permission :read_private_gws_gkan_attendance_overtime_files, module_name: 'gws/gkan'
    Gws::Role.permission :edit_other_gws_gkan_attendance_overtime_files, module_name: 'gws/gkan'
    Gws::Role.permission :edit_private_gws_gkan_attendance_overtime_files, module_name: 'gws/gkan'
    Gws::Role.permission :delete_other_gws_gkan_attendance_overtime_files, module_name: 'gws/gkan'
    Gws::Role.permission :delete_private_gws_gkan_attendance_overtime_files, module_name: 'gws/gkan'
    Gws::Role.permission :approve_private_gws_gkan_attendance_overtime_files, module_name: 'gws/gkan'
    Gws::Role.permission :approve_other_gws_gkan_attendance_overtime_files, module_name: 'gws/gkan'
    Gws::Role.permission :reroute_private_gws_gkan_attendance_overtime_files, module_name: 'gws/gkan'
    Gws::Role.permission :reroute_other_gws_gkan_attendance_overtime_files, module_name: 'gws/gkan'

    # holiday_work_files
    Gws::Role.permission :read_other_gws_gkan_attendance_holiday_work_files, module_name: 'gws/gkan'
    Gws::Role.permission :read_private_gws_gkan_attendance_holiday_work_files, module_name: 'gws/gkan'
    Gws::Role.permission :edit_other_gws_gkan_attendance_holiday_work_files, module_name: 'gws/gkan'
    Gws::Role.permission :edit_private_gws_gkan_attendance_holiday_work_files, module_name: 'gws/gkan'
    Gws::Role.permission :delete_other_gws_gkan_attendance_holiday_work_files, module_name: 'gws/gkan'
    Gws::Role.permission :delete_private_gws_gkan_attendance_holiday_work_files, module_name: 'gws/gkan'
    Gws::Role.permission :approve_private_gws_gkan_attendance_holiday_work_files, module_name: 'gws/gkan'
    Gws::Role.permission :approve_other_gws_gkan_attendance_holiday_work_files, module_name: 'gws/gkan'
    Gws::Role.permission :reroute_private_gws_gkan_attendance_holiday_work_files, module_name: 'gws/gkan'
    Gws::Role.permission :reroute_other_gws_gkan_attendance_holiday_work_files, module_name: 'gws/gkan'

    # leave_files
    Gws::Role.permission :read_other_gws_gkan_attendance_leave_files, module_name: 'gws/gkan'
    Gws::Role.permission :read_private_gws_gkan_attendance_leave_files, module_name: 'gws/gkan'
    Gws::Role.permission :edit_other_gws_gkan_attendance_leave_files, module_name: 'gws/gkan'
    Gws::Role.permission :edit_private_gws_gkan_attendance_leave_files, module_name: 'gws/gkan'
    Gws::Role.permission :delete_other_gws_gkan_attendance_leave_files, module_name: 'gws/gkan'
    Gws::Role.permission :delete_private_gws_gkan_attendance_leave_files, module_name: 'gws/gkan'
    Gws::Role.permission :approve_private_gws_gkan_attendance_leave_files, module_name: 'gws/gkan'
    Gws::Role.permission :approve_other_gws_gkan_attendance_leave_files, module_name: 'gws/gkan'
    Gws::Role.permission :reroute_private_gws_gkan_attendance_leave_files, module_name: 'gws/gkan'
    Gws::Role.permission :reroute_other_gws_gkan_attendance_leave_files, module_name: 'gws/gkan'

    # attendance work_days
    Gws::Role.permission :use_gws_gkan_attendance_work_days, module_name: 'gws/gkan'

    # locations
    Gws::Role.permission :use_gws_gkan_attendance_locations, module_name: 'gws/gkan'

    # workflow routes
    Gws::Role.permission :use_gws_gkan_workflow_routes, module_name: 'gws/gkan'

    # manage attendances
    Gws::Role.permission :use_private_gws_gkan_manage_attendances, module_name: 'gws/gkan'
    Gws::Role.permission :use_other_gws_gkan_manage_attendances, module_name: 'gws/gkan'

    # manage works
    Gws::Role.permission :use_private_gws_gkan_manage_works, module_name: 'gws/gkan'
    Gws::Role.permission :use_other_gws_gkan_manage_works, module_name: 'gws/gkan'

    # manage payment
    Gws::Role.permission :use_private_gws_gkan_manage_payments, module_name: 'gws/gkan'
    Gws::Role.permission :use_other_gws_gkan_manage_payments, module_name: 'gws/gkan'

    # settings
    Gws::Role.permission :use_gws_gkan_admin_settings, module_name: 'gws/gkan'

    Gws.module_usable :gkan do |site, user|
      Gws::Gkan.allowed?(:use, user, site: site)
    end
  end
end
