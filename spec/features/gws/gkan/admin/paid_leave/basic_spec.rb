require 'spec_helper'

describe "gws_gkan_admin_paid_leave", type: :feature, dbscope: :example, js: true do
  before { create_gkan }
  let!(:site) { gkan_site }
  let!(:user) { gkan_user("101") }
  let!(:attendance) { Gws::Gkan::AttendanceSetting.current_setting(site, user, Time.zone.now) }

  let!(:date) { Time.zone.today }
  let!(:effective_days) { 10 }
  let!(:remark) { unique_id }

  let!(:date2) { Time.zone.tomorrow }
  let!(:effective_days2) { 20 }
  let!(:remark2) { unique_id }

  let(:show_path) { gws_gkan_admin_user_attendance_setting_path site.id, user.id, attendance.id }

  context "basic" do
    before { login_user(user) }

    it "#show" do
      visit show_path
      expect(current_path).not_to eq sns_login_path

      # add
      within "#addon-gws-agents-addons-gkan-attendance_setting-paid_leave" do
        within "table.paid-leave-3hours" do
          expect(page).to have_css("td", text: I18n.t("gws/gkan.views.no_settings"))
        end
        within "table.paid-leave-4hours" do
          expect(page).to have_css("td", text: I18n.t("gws/gkan.views.no_settings"))
        end
        within "table.paid-leave-5hours" do
          expect(page).to have_css("td", text: I18n.t("gws/gkan.views.no_settings"))
        end
        within "table.paid-leave-6hours" do
          expect(page).to have_css("td", text: I18n.t("gws/gkan.views.no_settings"))
        end
        within "table.paid-leave-7hours" do
          expect(page).to have_css("td", text: I18n.t("gws/gkan.views.no_settings"))
        end
        within "table.paid-leave-8hours" do
          expect(page).to have_css("td", text: I18n.t("gws/gkan.views.no_settings"))
        end

        click_on I18n.t("ss.buttons.add")
      end
      within "form#item-form" do
        select I18n.t("gws/gkan.options.hour_type.8hours"), from: "item[hour_type]"
        fill_in_date "item[start_date]", with: date
        fill_in "item[effective_days]", with: effective_days
        fill_in "item[remark]", with: remark
        click_on I18n.t("ss.buttons.save")
      end
      wait_for_notice I18n.t("ss.notice.saved")

      within "#addon-gws-agents-addons-gkan-attendance_setting-paid_leave" do
        within "table.paid-leave-3hours" do
          expect(page).to have_css("td", text: I18n.t("gws/gkan.views.no_settings"))
        end
        within "table.paid-leave-4hours" do
          expect(page).to have_css("td", text: I18n.t("gws/gkan.views.no_settings"))
        end
        within "table.paid-leave-5hours" do
          expect(page).to have_css("td", text: I18n.t("gws/gkan.views.no_settings"))
        end
        within "table.paid-leave-6hours" do
          expect(page).to have_css("td", text: I18n.t("gws/gkan.views.no_settings"))
        end
        within "table.paid-leave-7hours" do
          expect(page).to have_css("td", text: I18n.t("gws/gkan.views.no_settings"))
        end
        within "table.paid-leave-8hours" do
          expect(page).to have_no_css("td", text: I18n.t("gws/gkan.views.no_settings"))
          expect(page).to have_css("table td", text: I18n.l(date, format: :picker))
          expect(page).to have_css("table td", text: effective_days)
          expect(page).to have_css("table td", text: remark)
        end
      end

      # edit
      within "#addon-gws-agents-addons-gkan-attendance_setting-paid_leave" do
        within "table.paid-leave-8hours" do
          click_on I18n.t("ss.buttons.edit")
        end
      end
      within "form#item-form" do
        fill_in_date "item[start_date]", with: date2
        fill_in "item[effective_days]", with: effective_days2
        fill_in "item[remark]", with: remark2
        click_on I18n.t("ss.buttons.save")
      end
      wait_for_notice I18n.t("ss.notice.saved")

      within "#addon-gws-agents-addons-gkan-attendance_setting-paid_leave" do
        within "table.paid-leave-3hours" do
          expect(page).to have_css("td", text: I18n.t("gws/gkan.views.no_settings"))
        end
        within "table.paid-leave-4hours" do
          expect(page).to have_css("td", text: I18n.t("gws/gkan.views.no_settings"))
        end
        within "table.paid-leave-5hours" do
          expect(page).to have_css("td", text: I18n.t("gws/gkan.views.no_settings"))
        end
        within "table.paid-leave-6hours" do
          expect(page).to have_css("td", text: I18n.t("gws/gkan.views.no_settings"))
        end
        within "table.paid-leave-7hours" do
          expect(page).to have_css("td", text: I18n.t("gws/gkan.views.no_settings"))
        end
        within "table.paid-leave-8hours" do
          expect(page).to have_no_css("td", text: I18n.t("gws/gkan.views.no_settings"))
          expect(page).to have_css("td", text: I18n.l(date2, format: :picker))
          expect(page).to have_css("td", text: effective_days2)
          expect(page).to have_css("td", text: remark2)
        end
      end

      # delete
      within "#addon-gws-agents-addons-gkan-attendance_setting-paid_leave" do
        within "table.paid-leave-8hours" do
          click_on I18n.t("ss.buttons.delete")
        end
      end
      within "form#item-form" do
        click_button I18n.t('ss.buttons.delete')
      end
      within "#addon-gws-agents-addons-gkan-attendance_setting-paid_leave" do
        within "table.paid-leave-3hours" do
          expect(page).to have_css("td", text: I18n.t("gws/gkan.views.no_settings"))
        end
        within "table.paid-leave-4hours" do
          expect(page).to have_css("td", text: I18n.t("gws/gkan.views.no_settings"))
        end
        within "table.paid-leave-5hours" do
          expect(page).to have_css("td", text: I18n.t("gws/gkan.views.no_settings"))
        end
        within "table.paid-leave-6hours" do
          expect(page).to have_css("td", text: I18n.t("gws/gkan.views.no_settings"))
        end
        within "table.paid-leave-7hours" do
          expect(page).to have_css("td", text: I18n.t("gws/gkan.views.no_settings"))
        end
        within "table.paid-leave-8hours" do
          expect(page).to have_css("td", text: I18n.t("gws/gkan.views.no_settings"))
        end
      end
    end
  end
end
