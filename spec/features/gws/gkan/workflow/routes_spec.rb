require 'spec_helper'

describe "gws_gkan_workflow_routes", type: :feature, dbscope: :example, js: true do
  before { create_gkan }
  let!(:site) { gkan_site }
  let!(:user1) { gkan_user("101") }
  let!(:user2) { gkan_user("105") }
  let!(:item1) { create :gws_workflow_route, user_id: user1.id }
  let!(:item2) { create :gws_workflow_route, user_id: user2.id }

  let(:index_path) { gws_gkan_workflow_routes_path site }
  let(:show_path) { gws_gkan_workflow_route_path site, item1 }
  let(:edit_path) { edit_gws_gkan_workflow_route_path site, item1 }
  let(:delete_path) { delete_gws_gkan_workflow_route_path site, item1 }

  context "basic" do
    before { login_user(user1) }

    it "#index" do
      visit index_path
      expect(current_path).not_to eq sns_login_path

      within ".list-items" do
        expect(page).to have_css(".list-item", text: item1.name)
        expect(page).to have_no_css(".list-item", text: item2.name)
        click_on item1.name
      end
      within "#addon-basic" do
        expect(page).to have_css("dd", text: item1.name)
      end
    end

    it "#show" do
      visit show_path
      within "#addon-basic" do
        expect(page).to have_css("dd", text: item1.name)
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
