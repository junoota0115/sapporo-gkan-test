class Gws::Gkan::Manage::Payment::Internal::MainController < ApplicationController
  include Gws::BaseFilter

  def index
    redirect_to gws_gkan_manage_payment_internal_overtime_path
  end
end
