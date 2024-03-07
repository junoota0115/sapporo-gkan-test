class Gws::Gkan::Manage::Work::SearchWorkRecord
  extend SS::Translation
  include ActiveModel::Model
  include Gws::Gkan::SearchParams
  include Gws::Gkan::SearchPermission

  set_permission_name 'gws_gkan_manage_works', :use

  attr_accessor :only_manage_member, :organization_uid, :group_id,
    :user_title_id, :start, :close, :reason

  permit_params :only_manage_member, :organization_uid, :group_id,
    :user_title_id, :start, :close, :reason

  def group_options
    @groups ||= site.descendants.active.tree_sort(root_name: site.name)
    @groups.to_options
  end

  def user_title_options
    @user_titles ||= Gws::UserTitle.site(site)
    @user_titles.pluck(:name, :id)
  end

  def t(name, opts = {})
    self.class.t name, opts
  end
end
