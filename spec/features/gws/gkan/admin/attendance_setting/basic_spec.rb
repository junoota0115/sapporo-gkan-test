require 'spec_helper'

describe "gws_gkan_admin_attendance_settings", type: :feature, dbscope: :example, js: true do
  before { create_gkan }
  let!(:site) { gkan_site }
  let!(:user) { gkan_user("101") }
  let!(:attendance) { Gws::Gkan::AttendanceSetting.current_setting(site, user, Time.zone.now) }

  let(:index_path) { gws_gkan_admin_user_attendance_settings_path site.id, user.id }
  let(:show_path) { gws_gkan_admin_user_attendance_setting_path site.id, user.id, attendance.id }
  let(:edit_path) { edit_gws_gkan_admin_user_attendance_setting_path site.id, user.id, attendance.id }
  let(:delete_path) { delete_gws_gkan_admin_user_attendance_setting_path site.id, user.id, attendance.id }

  context "basic" do
    before { login_user(user) }

    it "#index" do
      visit index_path
      expect(current_path).not_to eq sns_login_path

      within "table" do
        expect(page).to have_css("td", text: attendance.name)
        click_on attendance.name
      end
      within "#addon-basic" do
        expect(page).to have_css("dd", text: user.long_name)
        expect(page).to have_css("dd", text: attendance.duty_setting.name)
        expect(page).to have_css("dd", text: attendance.leave_setting.name)
      end
    end

    it "#show" do
      visit show_path
      within "#addon-basic" do
        expect(page).to have_css("dd", text: user.long_name)
        expect(page).to have_css("dd", text: attendance.duty_setting.name)
        expect(page).to have_css("dd", text: attendance.leave_setting.name)
      end
    end

    it "#edit" do
      visit edit_path
      within "form#item-form" do
        click_button I18n.t('ss.buttons.save')
      end
      wait_for_notice I18n.t("ss.notice.saved")
    end

    it "#delete" do
      visit delete_path
      within "form#item-form" do
        click_button I18n.t('ss.buttons.delete')
      end
      expect(current_path).to eq index_path
    end
  end
end
