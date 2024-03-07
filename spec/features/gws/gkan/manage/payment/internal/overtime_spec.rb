require 'spec_helper'

describe "gws_gkan_manage_payment_internal_overtime", type: :feature, dbscope: :example, js: true do
  before { create_gkan }
  let!(:site) { gkan_site }
  let!(:user) { gkan_user("101") }

  let(:index_path) { gws_gkan_manage_payment_internal_overtime_path site.id }

  context "basic" do
    before { login_user(user) }

    it "#index" do
      visit index_path
      expect(current_path).not_to eq sns_login_path

      within "form#item-form" do
        click_on I18n.t("ss.buttons.download")
      end
      wait_for_download

      csv = ::CSV.read(downloads.first, headers: true)
      expect(csv.headers.size).to eq 1
    end
  end
end
