require 'spec_helper'

describe "gws_portal_setting_organization", type: :feature, dbscope: :example, js: true do
  let(:site) { gws_site }
  let(:user) { gws_user }

  context "least required permissions to manage" do
    let!(:notice_folder) { create(:gws_notice_folder, cur_site: site) }
    let!(:notice_post) { create(:gws_notice_post, cur_site: site, folder_id: notice_folder.id) }
    let!(:schedule_plan) { create(:gws_schedule_plan, cur_site: site) }
    let(:permissions) do
      permissions = []
      permissions << 'use_gws_portal_organization_settings'
      permissions << 'read_other_gws_portal_group_settings'
      permissions << 'edit_other_gws_portal_group_settings'
      permissions << 'delete_other_gws_portal_group_settings'
      # ポータルにお知らせを表示するために必要
      permissions << 'use_gws_notice'
      permissions << 'read_private_gws_notices'
      # ポータルにスケジュールを表示するために必要
      permissions << 'use_private_gws_schedule_plans'
      permissions << 'read_private_gws_schedule_plans'
      permissions
    end
    let(:role) { create(:gws_role, cur_site: site, permissions: permissions) }

    before do
      user.gws_role_ids = [role.id]
      user.save!

      login_user user
    end

    it do
      visit gws_portal_path(site: site)
      expect(page).to have_css(".gws-notices", text: notice_post.name)
      expect(page).to have_css(".gws-portlets .portlet-model-schedule", text: schedule_plan.name)
      within ".current-navi" do
        click_on I18n.t("gws/portal.tabs.root_portal")
      end
      within ".breadcrumb" do
        expect(page).to have_content(I18n.t("gws/portal.tabs.root_portal"))
      end
      within ".current-navi" do
        expect(page).to have_content(I18n.t('gws/portal.links.arrange_portlets'))
        expect(page).to have_content(I18n.t('gws/portal.links.manage_portlets'))
        expect(page).to have_content(I18n.t('gws/portal.links.settings'))
      end

      click_on I18n.t('gws/portal.links.arrange_portlets')
      click_on I18n.t("ss.buttons.reset")
      expect(page).to have_css(".gws-portlets .portlet-model-schedule", text: schedule_plan.name)

      click_on I18n.t('gws/portal.links.manage_portlets')
      click_on I18n.t('ss.links.initialize')
      within "form" do
        page.accept_alert(/#{::Regexp.escape(I18n.t("ss.confirm.initialize"))}/) do
          click_on I18n.t('ss.buttons.initialize')
        end
      end

      click_on I18n.t('gws/portal.links.settings')
      click_on I18n.t('ss.links.edit')
      within "form" do
        click_on I18n.t('ss.buttons.save')
      end
      wait_for_notice I18n.t("ss.notice.saved")
    end
  end

  context "least required permissions to show" do
    let!(:notice_folder) { create(:gws_notice_folder, cur_site: site) }
    let!(:notice_post) { create(:gws_notice_post, cur_site: site, folder_id: notice_folder.id) }
    let!(:schedule_plan) { create(:gws_schedule_plan, cur_site: site) }
    let(:permissions) do
      permissions = []
      permissions << 'use_gws_portal_organization_settings'
      # ポータルにお知らせを表示するために必要
      permissions << 'use_gws_notice'
      permissions << 'read_private_gws_notices'
      # ポータルにスケジュールを表示するために必要
      permissions << 'use_private_gws_schedule_plans'
      permissions << 'read_private_gws_schedule_plans'
      permissions
    end
    let(:role) { create(:gws_role, cur_site: site, permissions: permissions) }

    before do
      user.gws_role_ids = [role.id]
      user.save!

      login_user user
    end

    it do
      visit gws_portal_path(site: site)
      expect(page).to have_css(".gws-notices", text: notice_post.name)
      expect(page).to have_css(".gws-portlets .portlet-model-schedule", text: schedule_plan.name)
      within ".current-navi" do
        click_on I18n.t("gws/portal.tabs.root_portal")
      end
      within ".breadcrumb" do
        expect(page).to have_content(I18n.t("gws/portal.tabs.root_portal"))
      end
      within ".current-navi" do
        expect(page).to have_no_content(I18n.t('gws/portal.links.arrange_portlets'))
        expect(page).to have_no_content(I18n.t('gws/portal.links.manage_portlets'))
        expect(page).to have_no_content(I18n.t('gws/portal.links.settings'))
      end
    end
  end
end
