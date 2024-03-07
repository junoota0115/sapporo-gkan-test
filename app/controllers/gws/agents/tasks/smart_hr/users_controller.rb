class Gws::Agents::Tasks::SmartHr::UsersController < ApplicationController
  def import
    @task.log "\# #{@site.name}"
    @task.log "ユーザーインポート開始"
    @task.log "..."
    @task.log "完了"
    head :ok
  end
end
