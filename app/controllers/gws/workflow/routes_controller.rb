class Gws::Workflow::RoutesController < ApplicationController
  include Gws::BaseFilter
  include Gws::CrudFilter

  model Gws::Workflow::Route

  prepend_view_path 'app/views/workflow/routes'
  navi_view "gws/workflow/main/navi"

  private

  def set_crumbs
    @crumbs << [@cur_site.menu_workflow_label || t('modules.gws/workflow'), gws_workflow_setting_path]
    @crumbs << [@model.model_name.human, action: :index]
  end

  def fix_params
    { cur_user: @cur_user, cur_site: @cur_site }
  end

  def set_item
    super
    raise "403" if @item.user_id != @cur_user.id
  end

  public

  def index
    raise "403" unless @model.allowed?(:use, @cur_user, site: @cur_site)
    @items = @model.user(@cur_user)
  end
end
