class Gws::Gkan::Workflow::RoutesController < ApplicationController
  include Gws::BaseFilter
  include Gws::CrudFilter
  include Gws::Gkan::AttendanceFilter

  model Gws::Gkan::Workflow::Route

  prepend_view_path 'app/views/workflow/routes'
  navi_view "gws/gkan/attendance/main/navi"

  private

  def set_crumbs
    @crumbs << [ @cur_site.menu_gkan_attendance_label || t('modules.gws/gkan/attendance'), gws_gkan_attendance_main_path ]
    @crumbs << [ t("modules.gws/gkan/workflow/route"), action: :index ]
  end

  def fix_params
    { cur_user: @cur_user, cur_site: @cur_site }
  end

  def set_item
    super
    raise "403" if @item.user_id != @cur_user.id
  end

  public

  def index
    raise "403" unless @model.allowed?(:use, @cur_user, site: @cur_site)
    @items = @model.user(@cur_user)
  end
end
