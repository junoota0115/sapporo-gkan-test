class Gws::Gkan::Attendance::SettingsController < ApplicationController
  include Gws::BaseFilter
  include Gws::CrudFilter
  include Gws::Gkan::AttendanceFilter

  model Gws::Gkan::AttendanceSetting

  navi_view "gws/gkan/attendance/main/navi"

  before_action :set_item

  private

  def set_crumbs
    @crumbs << [ @cur_site.menu_gkan_attendance_label || t('modules.gws/gkan/attendance'), gws_gkan_attendance_main_path ]
    @crumbs << [ t('modules.gws/gkan/attendance/setting'), { action: :show } ]
  end

  def fix_params
    { cur_user: @cur_user, cur_site: @cur_site }
  end

  def set_item
    @item = @cur_attendance
    @addons = []
  end

  public

  def show
    #raise "403" unless @item.allowed?(:read, @cur_user, site: @cur_site)
    render
  end

  def edit
    #raise "403" unless @item.allowed?(:edit, @cur_user, site: @cur_site)
    render
  end

  def update
    @item.attributes = get_params
    @item.in_updated = params[:_updated] if @item.respond_to?(:in_updated)
    #return render_update(false) unless @item.allowed?(:edit, @cur_user, site: @cur_site)
    render_update @item.update
  end
end
