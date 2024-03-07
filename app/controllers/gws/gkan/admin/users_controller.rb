class Gws::Gkan::Admin::UsersController < ApplicationController
  include Gws::BaseFilter
  include Gws::CrudFilter

  model Gws::Gkan::AttendanceSetting

  navi_view "gws/gkan/admin/main/navi"

  private

  def set_crumbs
    @crumbs << [ @cur_site.menu_gkan_attendance_label || t('modules.gws/gkan/attendance'), gws_gkan_attendance_main_path ]
    @crumbs << [ t('modules.gws/gkan/admin/attendance_setting'), action: :index ]
  end

  def group_ids
    if params[:s].present? && params[:s][:group].present?
      @group = @cur_site.descendants.active.find(params[:s][:group]) rescue nil
    end
    @group ||= @cur_site
    @group_ids ||= @cur_site.descendants_and_self.active.in_group(@group).pluck(:id)
  end

  public

  def index
    raise "403" unless @model.allowed?(:use, @cur_user, site: @cur_site)

    @groups = @cur_site.descendants.active.tree_sort(root_name: @cur_site.name)

    @s = OpenStruct.new(params[:s])
    @s.cur_site = @cur_site

    @items = Gws::User.site(@cur_site).
      state(params.dig(:s, :state)).
      in(group_ids: group_ids).
      search(@s).
      order_by_title(@cur_site).
      page(params[:page]).per(50)

    date = Time.zone.now
    @attendances = @model.site(@cur_site).in(user_id: @items.pluck(:id)).and([
      { start_date: { "$lte" => date.to_date } },
      { "$or" => [
        { close_date: { "$gte" => date.to_date } },
        { close_date: nil },
      ]}
    ]).to_a
  end

  def import
  end

  def import_paid_leave
  end

  def download
  end
end
