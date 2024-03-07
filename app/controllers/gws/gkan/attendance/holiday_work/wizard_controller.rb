class Gws::Gkan::Attendance::HolidayWork::WizardController < ApplicationController
  include Gws::ApiFilter
  include Gws::Workflow::WizardFilter

  private

  def set_model
    @model = Gws::Gkan::Attendance::HolidayWorkFile
  end

  def fix_params
    { cur_user: @cur_user, cur_site: @cur_site }
  end
end
