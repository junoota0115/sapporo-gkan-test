require 'spec_helper'

describe "gws_gkan_admin_users", type: :feature, dbscope: :example, js: true do
  before { create_gkan }
  let!(:site) { gkan_site }
  let!(:user) { gkan_user("101") }
  let!(:attendance) { Gws::Gkan::AttendanceSetting.current_setting(site, user, Time.zone.now) }

  let(:index_path) { gws_gkan_admin_users_path site.id }

  context "basic" do
    before { login_user(user) }

    it "#index" do
      visit index_path
      expect(current_path).not_to eq sns_login_path

      within ".list-items" do
        expect(page).to have_css(".list-item", text: user.name)
        click_on user.name
      end
      within "table" do
        expect(page).to have_css("td", text: attendance.name)
        click_on attendance.name
      end
    end
  end
end
