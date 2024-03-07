class Gws::Gkan::Attendance::TimeCard::WizardController < ApplicationController
  include Gws::ApiFilter
  include Gws::Gkan::WizardFilter

  private

  def set_model
    @model = Gws::Gkan::Attendance::TimeCard
  end

  def fix_params
    { cur_user: @cur_user, cur_site: @cur_site }
  end
end
