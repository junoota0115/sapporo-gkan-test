require 'spec_helper'

describe "gws_gkan_manage_work_members", type: :feature, dbscope: :example, js: true do
  before { create_gkan }
  let!(:site) { gkan_site }
  let!(:user) { gkan_user("101") }
  let!(:user2) { gkan_user("102") }
  let!(:attendance2) { Gws::Gkan::AttendanceSetting.current_setting(site, user2, Time.zone.now) }

  let(:index_path) { gws_gkan_manage_work_members_path site.id }

  context "basic" do
    before { login_user(user) }

    it "#index" do
      visit index_path
      expect(current_path).not_to eq sns_login_path
      expect(page).to have_css("table td", text: I18n.t("gws/gkan.views.no_settings"))
    end

    it "#index" do
      attendance2.manager = user
      attendance2.update!

      visit index_path
      expect(current_path).not_to eq sns_login_path
      expect(page).to have_css("table td", text: user2.long_name)
    end
  end
end
