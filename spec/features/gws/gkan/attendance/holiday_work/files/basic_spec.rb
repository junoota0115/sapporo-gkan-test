require 'spec_helper'

describe "gws_gkan_attendance_holiday_work_files", type: :feature, dbscope: :example, js: true do
  before { create_gkan }
  let!(:site) { gkan_site }
  let!(:user) { gkan_user("101") }
  let!(:item) { create :gws_gkan_attendance_holiday_work_file }

  let(:index_path) { gws_gkan_attendance_holiday_work_files_path site }
  let(:show_path) { gws_gkan_attendance_holiday_work_file_path site, item }
  let(:edit_path) { edit_gws_gkan_attendance_holiday_work_file_path site, item }
  let(:delete_path) { delete_gws_gkan_attendance_holiday_work_file_path site, item }

  context "basic" do
    before { login_user(user) }

    it "#index" do
      visit index_path
      expect(current_path).not_to eq sns_login_path

      within ".list-items" do
        expect(page).to have_css(".list-item", text: item.long_name)
        click_on item.name
      end
      within "#addon-basic" do
        expect(page).to have_css("dd", text: item.name)
      end
    end

    it "#show" do
      visit show_path
      within "#addon-basic" do
        expect(page).to have_css("dd", text: item.name)
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
