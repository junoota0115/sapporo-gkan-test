class Gws::Gkan::Attendance::Leave::WizardController < ApplicationController
  include Gws::ApiFilter
  include Gws::Workflow::WizardFilter

  private

  def set_model
    @model = Gws::Gkan::Attendance::LeaveFile
  end

  def fix_params
    { cur_user: @cur_user, cur_site: @cur_site }
  end
end
