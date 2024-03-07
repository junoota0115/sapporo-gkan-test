module Gws
  module GkanSupport
    cattr_accessor :data

    module Hooks
      def self.extended(obj)
        dbscope = obj.metadata[:dbscope]
        dbscope ||= RSpec.configuration.default_dbscope

        obj.after(dbscope) do
          Gws::GkanSupport.data = nil
        end
      end
    end

    module_function

    def create_gkan
      return Gws::GkanSupport.data if Gws::GkanSupport.data.present?

      g1 = Gws::Group.create name: "札幌児童館", order: 10
      g2 = Gws::Group.create name: "札幌児童館/こども若者事業部", order: 20
      g3 = Gws::Group.create name: "札幌児童館/こども若者事業部/こども育成課", order: 30
      g4 = Gws::Group.create name: "札幌児童館/こども若者事業部/こども育成課/中央・南・手稲", order: 40
      g5 = Gws::Group.create name: "札幌児童館/こども若者事業部/こども育成課/中央・南・手稲/中央Ⅰ", order: 50
      g6 = Gws::Group.create name: "札幌児童館/こども若者事業部/こども育成課/中央・南・手稲/中央Ⅰ/宮の森児童会館", order: 60
      g7 = Gws::Group.create name: "札幌児童館/こども若者事業部/こども育成課/中央・南・手稲/中央Ⅰ/宮の森児童会館/新小ミニ児童会館", order: 70

      r1 = Gws::Role.create name: "admin", site_id: g1.id,
        permissions: Gws::Role.permission_names, permission_level: 3
      r2 = Gws::Role.create name: "manager", site_id: g1.id,
        permissions: load_gws_permissions('gkan/roles/manager_permissions.txt'), permission_level: 3
      r3 = Gws::Role.create name: "regular", site_id: g1.id,
        permissions: load_gws_permissions('gkan/roles/regular_permissions.txt'), permission_level: 3
      r4 = Gws::Role.create name: "parttimer", site_id: g1.id,
        permissions: load_gws_permissions('gkan/roles/parttimer_permissions.txt'), permission_level: 3

      sys = Gws::User.create name: "gws-sys", uid: "sys", email: "sys@example.jp", in_password: "pass",
        group_ids: [g1.id], gws_role_ids: [r1.id]
      u1 = Gws::User.create name: "係長職員A", uid: "101", organization_uid: "101", in_password: "pass",
        group_ids: [g6.id], gws_role_ids: [r2.id], organization_id: g1.id
      u2 = Gws::User.create name: "一般職員B", uid: "102", organization_uid: "102", in_password: "pass",
        group_ids: [g6.id], gws_role_ids: [r3.id], organization_id: g1.id
      u3 = Gws::User.create name: "児童指導員C", uid: "103", organization_uid: "103", in_password: "pass",
        group_ids: [g6.id], gws_role_ids: [r3.id], organization_id: g1.id
      u4 = Gws::User.create name: "臨時職員D", uid: "104", organization_uid: "104", in_password: "pass",
        group_ids: [g6.id], gws_role_ids: [r3.id], organization_id: g1.id
      u5 = Gws::User.create name: "主任パートスタッフE", uid: "105", organization_uid: "105", in_password: "pass",
        group_ids: [g6.id], gws_role_ids: [r3.id], organization_id: g1.id
      u6 = Gws::User.create name: "パートスタッフF", uid: "106", organization_uid: "106", in_password: "pass",
        group_ids: [g6.id], gws_role_ids: [r4.id], organization_id: g1.id

      ::Gkan::DefaultSetting.new(g1).create_settings

      today = Time.zone.today
      s1 = Gws::Gkan::AttendanceSetting.find_or_create_by(
        site_id: g1.id,
        user_id: u1.id,
        in_start_year: today.year,
        in_start_month: today.month,
        duty_setting_id: Gws::Gkan::DutySetting.where(name: "[札幌] 事務局長・総合職").first.id,
        leave_setting_id: Gws::Gkan::LeaveSetting.find_by(name: "[札幌] 職員就業規則（一般）").id)
      s2 = Gws::Gkan::AttendanceSetting.find_or_create_by(
        site_id: g1.id,
        user_id: u2.id,
        in_start_year: today.year,
        in_start_month: today.month,
        duty_setting_id: Gws::Gkan::DutySetting.where(name: "[札幌] 事務局長・総合職").first.id,
        leave_setting_id: Gws::Gkan::LeaveSetting.find_by(name: "[札幌] 職員就業規則（一般）").id)
      s3 = Gws::Gkan::AttendanceSetting.find_or_create_by(
        site_id: g1.id,
        user_id: u3.id,
        in_start_year: today.year,
        in_start_month: today.month,
        duty_setting_id: Gws::Gkan::DutySetting.where(name: "[札幌] 児童指導員").first.id,
        leave_setting_id: Gws::Gkan::LeaveSetting.find_by(name: "[札幌] 児童指導員就業規則（33h）").id)
      s4 = Gws::Gkan::AttendanceSetting.find_or_create_by(
        site_id: g1.id,
        user_id: u4.id,
        in_start_year: today.year,
        in_start_month: today.month,
        duty_setting_id: Gws::Gkan::DutySetting.where(name: "[札幌] 臨時職員").first.id,
        leave_setting_id: Gws::Gkan::LeaveSetting.find_by(name: "[札幌] 期間雇用職員等就業規則").id)
      s5 = Gws::Gkan::AttendanceSetting.find_or_create_by(
        site_id: g1.id,
        user_id: u5.id,
        in_start_year: today.year,
        in_start_month: today.month,
        duty_setting_id: Gws::Gkan::DutySetting.where(name: "[札幌] 主任パートスタッフ").first.id,
        leave_setting_id: Gws::Gkan::LeaveSetting.find_by(name: "[札幌] 主任パートスタッフ就業規則").id)
      s6 = Gws::Gkan::AttendanceSetting.find_or_create_by(
        site_id: g1.id,
        user_id: u6.id,
        in_start_year: today.year,
        in_start_month: today.month,
        duty_setting_id: Gws::Gkan::DutySetting.where(name: "[札幌] パートタイム職員（A）").first.id,
        leave_setting_id: Gws::Gkan::LeaveSetting.find_by(name: "[札幌] 期間雇用職員等就業規則").id)


      return Gws::GkanSupport.data = {
        site: g1,
        users: [sys, u1, u2, u3, u4, u5, u6],
        sys_user: sys
      }
    end
  end
end

def load_gws_permissions(path)
  File.read("#{Rails.root}/db/seeds/#{path}").split(/\r?\n/).map(&:strip) & Gws::Role.permission_names
end

def create_gkan
  Gws::GkanSupport.create_gkan
end

def gkan_site
  create_gkan[:site]
end

def gkan_user(uid)
  create_gkan[:users].find { |user| user.uid == uid }
end

RSpec.configuration.extend(Gws::GkanSupport::Hooks)
