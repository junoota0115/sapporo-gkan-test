require 'spec_helper'

describe "gws_gkan_admin_duty_setting", type: :feature, dbscope: :example, js: true do
  before { create_gkan }
  let!(:site) { gkan_site }
  let!(:user) { gkan_user("101") }
  let!(:attendance) { Gws::Gkan::AttendanceSetting.current_setting(site, user, Time.zone.now) }
  let!(:item) { attendance.duty_setting }

  let(:index_path) { gws_gkan_admin_duty_settings_path site.id }
  let(:show_path) { gws_gkan_admin_duty_setting_path site.id, item.id }
  let(:edit_path) { edit_gws_gkan_admin_duty_setting_path site.id, item.id }
  let(:delete_path) { delete_gws_gkan_admin_duty_setting_path site.id, item.id }

  context "basic" do
    before { login_user(user) }

    it "#index" do
      visit index_path
      expect(current_path).not_to eq sns_login_path

      within ".list-items" do
        expect(page).to have_css(".list-item", text: item.name)
        click_on item.name
      end
      within "#addon-basic" do
        expect(page).to have_css("dd", text: item.name)
        expect(page).to have_css("dd", text: item.code)
        expect(page).to have_css("dd", text: item.label(:employee_type))
      end
    end

    it "#show" do
      visit show_path
      within "#addon-basic" do
        expect(page).to have_css("dd", text: item.name)
        expect(page).to have_css("dd", text: item.code)
        expect(page).to have_css("dd", text: item.label(:employee_type))
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
