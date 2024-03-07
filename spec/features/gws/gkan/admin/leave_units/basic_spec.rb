require 'spec_helper'

describe "gws_gkan_admin_leave_units", type: :feature, dbscope: :example, js: true do
  before { create_gkan }
  let!(:site) { gkan_site }
  let!(:user) { gkan_user("101") }
  let!(:attendance) { Gws::Gkan::AttendanceSetting.current_setting(site, user, Time.zone.now) }
  let!(:leave_setting) { attendance.leave_setting }

  let!(:leave) { Gws::Gkan::Leave.find_by(code: "0001") }
  let!(:leave2) { Gws::Gkan::Leave.find_by(code: "0002") }

  let(:show_path) { gws_gkan_admin_leave_setting_path site.id, leave_setting.id }

  context "basic" do
    before { login_user(user) }

    it "#show" do
      leave_setting.units.destroy_all

      visit show_path
      expect(current_path).not_to eq sns_login_path

      # add
      within "#addon-gws-agents-addons-gkan-leave_setting-unit" do
        expect(page).to have_css("table td", text: I18n.t("gws/gkan.views.no_settings"))
        click_on I18n.t("ss.buttons.add")
      end

      within "form#item-form" do
        select leave.name, from: "item[leave_id]"
        click_on I18n.t("ss.buttons.save")
      end
      wait_for_notice I18n.t("ss.notice.saved")

      within "#addon-gws-agents-addons-gkan-leave_setting-unit" do
        expect(page).to have_no_css("table td", text: I18n.t("gws/gkan.views.no_settings"))
        expect(page).to have_css("table td", text: leave.name)
      end

      # edit
      within "#addon-gws-agents-addons-gkan-leave_setting-unit" do
        click_on I18n.t("ss.buttons.edit")
      end

      within "form#item-form" do
        select leave2.name, from: "item[leave_id]"
        click_on I18n.t("ss.buttons.save")
      end
      wait_for_notice I18n.t("ss.notice.saved")

      within "#addon-gws-agents-addons-gkan-leave_setting-unit" do
        expect(page).to have_no_css("table td", text: I18n.t("gws/gkan.views.no_settings"))
        expect(page).to have_css("table td", text: leave2.name)
      end

      # delete
      within "#addon-gws-agents-addons-gkan-leave_setting-unit" do
        click_on I18n.t("ss.buttons.delete")
      end
      within "form#item-form" do
        click_button I18n.t('ss.buttons.delete')
      end
      within "#addon-gws-agents-addons-gkan-leave_setting-unit" do
        expect(page).to have_css("table td", text: I18n.t("gws/gkan.views.no_settings"))
      end
    end
  end
end
