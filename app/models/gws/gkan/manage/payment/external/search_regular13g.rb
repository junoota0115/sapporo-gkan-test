class Gws::Gkan::Manage::Payment::External::SearchRegular13g
  extend SS::Translation
  include ActiveModel::Model
  include Gws::Gkan::SearchParams
  include Gws::Gkan::SearchPermission

  set_permission_name 'gws_gkan_manage_payments', :use

  attr_accessor :group_id, :user_ids, :fiscal_year, :month, :dataset
  permit_params :fiscal_year, :month, :group_id, :dataset
  permit_params user_ids: []

  def group
    @group ||= Gws::Group.find(group_id) rescue nil
  end

  def users
    return nil unless user_ids
    @users ||= Gws::User.in(id: user_ids)
  end

  def dataset_options
    I18n.t("gws/gkan.options.dataset").map { |k, v| [v, k] }
  end
end
