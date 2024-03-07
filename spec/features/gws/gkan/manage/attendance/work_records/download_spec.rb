require 'spec_helper'

describe "gws_gkan_manage_attendance_import_work_records", type: :feature, dbscope: :example, js: true do
  before { create_gkan }
  let!(:site) { gkan_site }
  let!(:user) { gkan_user("101") }
  let!(:attendance) { Gws::Gkan::AttendanceSetting.current_setting(site, user, Time.zone.now) }

  let(:index_path) { gws_gkan_manage_attendance_work_records_download_path site.id }

  context "basic" do
    before { login_user(user) }

    it "#index" do
      visit index_path
      within "form#item-form" do
        click_on I18n.t("ss.buttons.download")
      end
      wait_for_download

      csv = ::CSV.read(downloads.first, headers: true)
      expect(csv.headers.size).to eq 1
    end
  end
end
