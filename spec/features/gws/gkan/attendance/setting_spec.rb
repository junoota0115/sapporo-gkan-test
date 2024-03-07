require 'spec_helper'

describe "gws_gkan_attendance_setting", type: :feature, dbscope: :example, js: true do
  before { create_gkan }
  let!(:site) { gkan_site }
  let!(:user1) { gkan_user("101") }
  let!(:user2) { gkan_user("101") }
  let!(:attendance) { Gws::Gkan::AttendanceSetting.current_setting(site, user1, Time.zone.now) }

  let(:index_path) { gws_gkan_attendance_setting_path site }

  context "basic" do
    before { login_user(user1) }

    it "#index" do
      visit index_path
      expect(current_path).not_to eq sns_login_path

      within "#addon-basic" do
        expect(page).to have_css("dd", text: attendance.name)
      end
      within ".nav-menu" do
        click_on I18n.t("ss.links.edit")
      end
      wait_cbox_open { click_on I18n.t("cms.apis.users.index") }
      wait_for_cbox do
        click_on user2.name
      end
      within "form#item-form" do
        click_button I18n.t('ss.buttons.save')
      end
      wait_for_notice I18n.t("ss.notice.saved")

      within "#addon-basic" do
        expect(page).to have_css("dd", text: user2.name)
      end
    end
  end
end
