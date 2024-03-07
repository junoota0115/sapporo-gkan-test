class Gws::Gkan::Manage::Attendance::WorkRecords::DownloadController < ApplicationController
  include Gws::BaseFilter
  include Gws::CrudFilter

  model Gws::Gkan::Attendance::WorkRecord::Downloader

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
    @item.start = Time.zone.today.beginning_of_month
    @item.close = Time.zone.today.end_of_month
    return if request.get? || request.head?

    @item.attributes = get_params
    send_enum @item.enum_csv, filename: "attendance_work_records_#{Time.zone.now.to_i}.csv"
  end
end
