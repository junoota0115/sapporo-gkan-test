class Gws::Gkan::Manage::Attendance::WorkRecords::ImportController < ApplicationController
  include Gws::BaseFilter
  include Gws::CrudFilter

  model Gws::Gkan::Attendance::WorkRecord::Importer

  navi_view "gws/gkan/manage/attendance/main/navi"

  private

  def set_crumbs
    @crumbs << [ @cur_site.menu_gkan_attendance_label || t('modules.gws/gkan/attendance'), gws_gkan_attendance_main_path ]
    @crumbs << [ t('modules.gws/gkan/manage/attendance'), gws_gkan_manage_attendance_main_path ]
    @crumbs << [ t('modules.gws/gkan/manage/attendance/work_records'), { action: :index } ]
  end

  def fix_params
    { cur_user: @cur_user, cur_site: @cur_site }
  end

  public

  def index
    raise "403" unless Gws::Gkan::Manage::Attendance.allowed?(:use, @cur_user, site: @cur_site)

    @item = @model.new
    return if request.get? || request.head?

    @item.attributes = get_params
    render_update @item.import, notice: I18n.t("ss.notice.imported"), location: { action: :index }, render: { template: :index }
  end
end
