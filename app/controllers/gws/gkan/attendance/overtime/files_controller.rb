class Gws::Gkan::Attendance::Overtime::FilesController < ApplicationController
  include Gws::BaseFilter
  include Gws::CrudFilter
  include Gws::Gkan::AttendanceFilter
  include Gws::Gkan::WorkflowFilter

  model Gws::Gkan::Attendance::OvertimeFile

  navi_view "gws/gkan/attendance/main/navi"

  before_action :set_state

  private

  def set_crumbs
    @crumbs << [ @cur_site.menu_gkan_attendance_label || t('modules.gws/gkan/attendance'), gws_gkan_attendance_main_path ]
    @crumbs << [ t('modules.gws/gkan/attendance/overtime'), gws_gkan_attendance_overtime_main_path ]
  end

  def fix_params
    { cur_user: @cur_user, cur_site: @cur_site, duty_setting: @cur_duty }
  end

  def set_state
    @state = params[:state]
  end

  public

  def index
    @items = @model.site(@cur_site)

    case @state
    when "mine"
      @items = @items.user(@cur_user)
      #criteria.where( target_user_id: user.id )
    when "approve"
      @items = @items.where(
        workflow_state: 'request',
        workflow_approvers: { '$elemMatch' => { 'user_id' => @cur_user.id, 'state' => 'request' } })
    when "all"
      @items = @items.allow(:read, @cur_user, site: @cur_site)
    else
      @items = @items.none
    end

    @items = @items.search(params[:s])
  end

  def show
    # 閲覧権限(所有)を考慮しない
    render
  end
end
