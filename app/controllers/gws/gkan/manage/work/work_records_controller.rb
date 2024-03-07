class Gws::Gkan::Manage::Work::WorkRecordsController < ApplicationController
  include Gws::BaseFilter
  include Gws::CrudFilter

  model Gws::Gkan::Manage::Work::SearchWorkRecord

  navi_view "gws/gkan/manage/work/main/navi"

  private

  def set_crumbs
    @crumbs << [ @cur_site.menu_gkan_attendance_label || t('modules.gws/gkan/attendance'), gws_gkan_attendance_main_path ]
    @crumbs << [ t('modules.gws/gkan/manage/work'), gws_gkan_manage_work_main_path ]
    @crumbs << [ t('modules.gws/gkan/manage/work/work_records'), { action: :index } ]
  end

  def fix_params
    { cur_site: @cur_site, cur_user: @cur_user }
  end

  public

  def index
    if request.get? || request.head?
      @item = @model.new fix_params
      return
    end

    @item = @model.new get_params
    raise "403" unless @item.allowed?(:use, @cur_user, site: @cur_site)

    @items = []
  end
end
