class Gws::Gkan::Manage::Payment::External::SearchParttime
  extend SS::Translation
  include ActiveModel::Model
  include Gws::Gkan::SearchParams
  include Gws::Gkan::SearchPermission

  set_permission_name 'gws_gkan_manage_payments', :use

  attr_accessor :group_id, :user_ids, :fiscal_year, :month, :duty_setting_ids
  permit_params :fiscal_year, :month, :group_id
  permit_params user_ids: []
  permit_params duty_setting_ids: []

  def group
    @group ||= Gws::Group.find(group_id) rescue nil
  end

  def users
    return nil unless user_ids
    @users ||= Gws::User.in(id: user_ids)
  end

  def duty_settings
    return nil unless duty_setting_ids
    @duty_settings ||= Gws::Gkan::DutySetting.in(id: duty_setting_ids)
  end
end
