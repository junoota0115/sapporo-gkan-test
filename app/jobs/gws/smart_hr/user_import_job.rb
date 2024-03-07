class Gws::SmartHr::UserImportJob < Gws::ApplicationJob
  include Job::Gws::TaskFilter

  self.task_class = Gws::Task
  self.task_name = "gws:smart_hr:user_import"
  self.controller = Gws::Agents::Tasks::SmartHr::UsersController
  self.action = :import

  def task_cond
    cond = { name: self.class.task_name }
    cond[:site_id] = site_id
    cond
  end

  def perform(opts = {})
    task.process self.class.controller, self.class.action, { site: site, user: user }
  end
end
