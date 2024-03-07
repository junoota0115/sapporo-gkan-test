class Gws::Agents::Tasks::SmartHr::GroupsController < ApplicationController
  def import
    @task.log "\# #{@site.name}"
    @task.log "グループインポート開始"
    @task.log "..."
    @task.log "完了"
    head :ok
  end
end
