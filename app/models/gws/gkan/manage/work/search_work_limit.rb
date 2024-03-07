class Gws::Gkan::Manage::Work::SearchWorkLimit
  extend SS::Translation
  include ActiveModel::Model
  include Gws::Gkan::SearchParams
  include Gws::Gkan::SearchPermission

  set_permission_name 'gws_gkan_manage_works', :use

  attr_accessor :group_id, :user_ids, :month, :limit_term

  permit_params :group_id, user_ids: []

  def group
    @group ||= Gws::Group.find(group_id) rescue nil
  end

  def users
    return nil unless user_ids
    @users ||= Gws::User.in(id: user_ids)
  end
end
