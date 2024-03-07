class Gws::Gkan::Manage::Work::SearchWorkTime
  extend SS::Translation
  include ActiveModel::Model
  include Gws::Gkan::SearchParams
  include Gws::Gkan::SearchPermission

  set_permission_name 'gws_gkan_manage_works', :use

  attr_accessor :group_id, :fiscal_year

  permit_params :group_id

  def group
    @group ||= Gws::Group.find(group_id) rescue nil
  end
end
