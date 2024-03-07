class Gws::Gkan::Manage::Payment::SearchAudit
  extend SS::Translation
  include ActiveModel::Model
  include Gws::Gkan::SearchParams
  include Gws::Gkan::SearchPermission

  set_permission_name 'gws_gkan_manage_payments', :use

  attr_accessor :export_unit, :start, :close, :leave_id, :group_ids, :user_ids, :duty_setting_ids

  permit_params :export_unit, :start, :close, :leave_id
  permit_params group_ids: []
  permit_params user_ids: []
  permit_params duty_setting_ids: []

  def groups
    return nil unless group_ids
    @groups ||= Gws::Group.in(id: group_ids)
  end

  def users
    return nil unless user_ids
    @users ||= Gws::User.in(id: user_ids)
  end

  def duty_settings
    return nil unless duty_setting_ids
    @duty_settings ||= Gws::Gkan::DutySetting.in(id: duty_setting_ids)
  end

  def export_unit_options
    I18n.t("gws/gkan.options.export_unit").map { |k, v| [v, k] }
  end
end
