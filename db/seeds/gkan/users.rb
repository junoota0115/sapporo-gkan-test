## -------------------------------------
# import gkan groups

puts "# import gkan groups"
path = "#{Rails.root}/db/seeds/gkan/csv/groups.csv"
file = SS::TempFile.create_empty!(filename: ::File.basename(path), content_type: 'text/csv') do |file|
  ::FileUtils.cp(path, file.path)
end
Sys::GroupImportJob.bind(site_id: @site, user_id: @sys).perform_now(file.id)

## -------------------------------------
# import user titles

puts "# import gkan user titles"
path = "#{Rails.root}/db/seeds/gkan/csv/user_titles.csv"
file = SS::TempFile.create_empty!(filename: ::File.basename(path), content_type: 'text/csv') do |file|
  ::FileUtils.cp(path, file.path)
end
Gws::UserTitleImportJob.bind(site_id: @site, user_id: @sys).perform_now(file.id)

## -------------------------------------
# import users

puts "# import gkan users"
path = "#{Rails.root}/db/seeds/gkan/csv/users.csv"
in_file = Fs::UploadedFile.create_from_file(path)
item = Gws::UserCsv::Importer.new(in_file: in_file, cur_site: @site, cur_user: @sys)
item.import

## -------------------------------------
# user attendance settings

puts "# gkan attendance settings"
today = Time.zone.today
u1 = Gws::User.find_by(name: "係長職員A")
s1 = Gws::Gkan::AttendanceSetting.find_or_create_by(
  site_id: @site.id,
  user_id: u1.id,
  in_start_year: today.year,
  in_start_month: today.month,
  duty_setting_id: Gws::Gkan::DutySetting.where(name: "[札幌] 事務局長・総合職").first.id,
  leave_setting_id: Gws::Gkan::LeaveSetting.find_by(name: "[札幌] 職員就業規則（一般）").id)

u2 = Gws::User.find_by(name: "一般職員B")
s2 = Gws::Gkan::AttendanceSetting.find_or_create_by(
  site_id: @site.id,
  user_id: u2.id,
  in_start_year: today.year,
  in_start_month: today.month,
  duty_setting_id: Gws::Gkan::DutySetting.where(name: "[札幌] 事務局長・総合職").first.id,
  leave_setting_id: Gws::Gkan::LeaveSetting.find_by(name: "[札幌] 職員就業規則（一般）").id)

u3 = Gws::User.find_by(name: "児童指導員C")
s3 = Gws::Gkan::AttendanceSetting.find_or_create_by(
  site_id: @site.id,
  user_id: u3.id,
  in_start_year: today.year,
  in_start_month: today.month,
  duty_setting_id: Gws::Gkan::DutySetting.where(name: "[札幌] 児童指導員").first.id,
  leave_setting_id: Gws::Gkan::LeaveSetting.find_by(name: "[札幌] 児童指導員就業規則（33h）").id)

u4 = Gws::User.find_by(name: "臨時職員D")
s4 = Gws::Gkan::AttendanceSetting.find_or_create_by(
  site_id: @site.id,
  user_id: u4.id,
  in_start_year: today.year,
  in_start_month: today.month,
  duty_setting_id: Gws::Gkan::DutySetting.where(name: "[札幌] 臨時職員").first.id,
  leave_setting_id: Gws::Gkan::LeaveSetting.find_by(name: "[札幌] 期間雇用職員等就業規則").id)

u5 = Gws::User.find_by(name: "主任パートスタッフE")
s5 = Gws::Gkan::AttendanceSetting.find_or_create_by(
  site_id: @site.id,
  user_id: u5.id,
  in_start_year: today.year,
  in_start_month: today.month,
  duty_setting_id: Gws::Gkan::DutySetting.where(name: "[札幌] 主任パートスタッフ").first.id,
  leave_setting_id: Gws::Gkan::LeaveSetting.find_by(name: "[札幌] 主任パートスタッフ就業規則").id)

u6 = Gws::User.find_by(name: "パートスタッフF")
s6 = Gws::Gkan::AttendanceSetting.find_or_create_by(
  site_id: @site.id,
  user_id: u6.id,
  in_start_year: today.year,
  in_start_month: today.month,
  duty_setting_id: Gws::Gkan::DutySetting.where(name: "[札幌] パートタイム職員（A）").first.id,
  leave_setting_id: Gws::Gkan::LeaveSetting.find_by(name: "[札幌] 期間雇用職員等就業規則").id)
