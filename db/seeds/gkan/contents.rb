## -------------------------------------

# set initial settings
@site.attributes = {
  memo_quota: 100, memo_filesize_limit: 3
}

# menus
@site.attributes = {
  menu_todo_state: "hide",
  menu_reminder_state: "hide",
  menu_presence_state: "hide",
  menu_attendance_state: "hide",
  menu_affair_state: "hide",
  menu_daily_report_state: "hide",
  menu_workload_state: "hide",
  menu_report_state: "hide",
  menu_circular_state: "hide",
  menu_monitor_state: "hide",
  menu_survey_state: "hide",
  menu_board_state: "hide",
  menu_faq_state: "hide",
  menu_qna_state: "hide",
  menu_discussion_state: "hide",
  menu_shared_address_state: "hide",
  menu_personal_address_state: "hide",
  menu_staff_record_state: "hide"
}
@site.save!

## -------------------------------------

#load "#{Rails.root}/db/seeds/gws/contents/custom_group.rb"
#load "#{Rails.root}/db/seeds/gws/contents/notice.rb"
#load "#{Rails.root}/db/seeds/gws/contents/link.rb"
#load "#{Rails.root}/db/seeds/gws/contents/discussion.rb"
#load "#{Rails.root}/db/seeds/gws/contents/facility.rb"
#load "#{Rails.root}/db/seeds/gws/contents/memo.rb"
#load "#{Rails.root}/db/seeds/gws/contents/schedule.rb"
#load "#{Rails.root}/db/seeds/gws/contents/todo.rb"
#load "#{Rails.root}/db/seeds/gws/contents/reminder.rb"
#load "#{Rails.root}/db/seeds/gws/contents/board.rb"
#load "#{Rails.root}/db/seeds/gws/contents/circular.rb"
#load "#{Rails.root}/db/seeds/gws/contents/faq.rb"
#load "#{Rails.root}/db/seeds/gws/contents/monitor.rb"
#load "#{Rails.root}/db/seeds/gws/contents/qna.rb"
#load "#{Rails.root}/db/seeds/gws/contents/report.rb"
#load "#{Rails.root}/db/seeds/gws/contents/share.rb"
#load "#{Rails.root}/db/seeds/gws/contents/user.rb"
#load "#{Rails.root}/db/seeds/gws/contents/workflow.rb"
#load "#{Rails.root}/db/seeds/gws/contents/bookmark.rb"
#load "#{Rails.root}/db/seeds/gws/contents/max.rb"
#load "#{Rails.root}/db/seeds/gws/contents/attendance.rb"
#load "#{Rails.root}/db/seeds/gws/contents/affair.rb"
#load "#{Rails.root}/db/seeds/gws/contents/daily_report.rb"
#load "#{Rails.root}/db/seeds/gws/contents/presence.rb"
#load "#{Rails.root}/db/seeds/gws/contents/survey.rb"
#load "#{Rails.root}/db/seeds/gws/contents/contrast.rb"
#load "#{Rails.root}/db/seeds/gws/contents/workload.rb"
#load "#{Rails.root}/db/seeds/gws/contents/aggregation.rb"
#load "#{Rails.root}/db/seeds/gws/contents/search_form.rb"
