puts 'gkan/site.rb'
site_name = "札幌児童館"

# --------------------------------------
# テナント（1階層グループ）
# 権限ロール sys, gws
# システム管理者

def save_group(data)
  if item = Gws::Group.where(name: data[:name]).first
    puts "exists #{data[:name]}"
    item.update! data
    return item
  end

  puts "create #{data[:name]}"
  item = Gws::Group.new(data)
  item.save
  item
end

def save_role(data)
  if item = Sys::Role.where(name: data[:name]).first
    puts "exists #{data[:name]}"
    item.update data
    return item
  end

  puts "create #{data[:name]}"
  item = Sys::Role.new(data)
  puts item.errors.full_messages unless item.save
  item
end

def save_gws_role(data)
  if item = Gws::Role.where(site_id: data[:site_id], name: data[:name]).first
    puts "exists #{data[:name]}"
    item.update data
    return item
  end

  puts "create #{data[:name]}"
  item = Gws::Role.new(data)
  item.save
  item
end

def load_gws_permissions(path)
  File.read("#{Rails.root}/db/seeds/#{path}").split(/\r?\n/).map(&:strip) & Gws::Role.permission_names
end

def save_user(data, only_on_creates = {})
  if item = SS::User.where(uid: data[:uid]).first
    puts "exists #{data[:name]}"
    item.update data
    return item
  end

  puts "create #{data[:name]}"
  SS::User.find_or_create_by!(email: data[:email]) do |item|
    item.attributes = data.merge(only_on_creates)
  end
end

puts "# groups"
@site = save_group name: site_name, order: 10

puts "# roles"
sys_r01 = save_role name: I18n.t('sys.roles.admin'), permissions: Sys::Role.permission_names
sys_r02 = save_role name: I18n.t('sys.roles.user'), permissions: %w(use_cms use_gws use_webmail)

puts "# users"
@sys = save_user(
  { name: "システム管理者", uid: "sys", email: "sys@example.jp", in_password: "pass", kana: "システムカンリシャ" },
  { type: SS::User::TYPE_SNS, login_roles: [ SS::User::LOGIN_ROLE_DBPASSWD ], group_ids: [@site.id], sys_role_ids: [sys_r01.id],
    organization_id: @site.id, organization_uid: "9999999", deletion_lock_state: "locked" }
)
@sys.add_to_set(group_ids: [@site.id], sys_role_ids: [sys_r01.id])

puts "# gws roles"
gws_r01 = save_gws_role name: I18n.t('gws.roles.admin'), site_id: @site.id,
  permissions: Gws::Role.permission_names, permission_level: 3
gws_r02 = save_gws_role name: "manager", site_id: @site.id,
  permissions: load_gws_permissions('gkan/roles/manager_permissions.txt'), permission_level: 3
gws_r02 = save_gws_role name: "regular", site_id: @site.id,
  permissions: load_gws_permissions('gkan/roles/regular_permissions.txt'), permission_level: 3
gws_r03 = save_gws_role name: "parttimer", site_id: @site.id,
  permissions: load_gws_permissions('gkan/roles/parttimer_permissions.txt'), permission_level: 3
Gws::User.find_by(uid: "sys").add_to_set(gws_role_ids: gws_r01.id)

