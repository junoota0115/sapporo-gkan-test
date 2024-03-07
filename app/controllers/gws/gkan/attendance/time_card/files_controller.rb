class Gws::Gkan::Attendance::TimeCard::FilesController < ApplicationController
  include Gws::BaseFilter
  include Gws::CrudFilter
  include Gws::Gkan::AttendanceFilter
  include Gws::Gkan::WorkflowFilter

  model Gws::Gkan::Attendance::TimeCard

  navi_view "gws/gkan/attendance/main/navi"

  private

  def fix_params
    { cur_user: @cur_user, cur_site: @cur_site }
  end

  public

  def show
    @hide_workflow_approve = true
    super
  end
end
