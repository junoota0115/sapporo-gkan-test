class Gws::SmartHr::SettingsController < ApplicationController
  include Gws::BaseFilter
  include Gws::CrudFilter

  navi_view "gws/smart_hr/main/navi"

  private

  def set_item
    @item = Gws::SmartHr::Setting.new
  end

  public

  def show
  end
end
