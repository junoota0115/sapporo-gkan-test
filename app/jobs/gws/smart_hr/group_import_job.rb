class Gws::SmartHr::GroupImportJob < Gws::ApplicationJob
  include Job::Gws::TaskFilter

  self.task_class = Gws::Task
  self.task_name = "gws:smart_hr::group_import"
  self.controller = Gws::Agents::Tasks::SmartHr::GroupsController
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
