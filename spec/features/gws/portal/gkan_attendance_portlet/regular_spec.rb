require 'spec_helper'

describe "gws_portal_circluar", type: :feature, dbscope: :example, js: true do
  before { create_gkan }
  let!(:site) { gkan_site }
  let!(:user) { gkan_user("101") }
  let(:reason) { unique_id }
  let(:memo) { unique_id }
  let(:travel_cost) { 600 }
  let!(:location1) { create :gws_gkan_attendance_location, cur_user: user }
  let!(:location2) { create :gws_gkan_attendance_location, cur_user: user }
  let!(:location3) { create :gws_gkan_attendance_location, cur_user: user }
  let(:attendance_path) { gws_gkan_attendance_time_card_main_path site.id }

  context "basic" do
    let(:now) { Time.zone.now.change(hour: 8, minute: 0) }
    around do |example|
      travel_to(now) { example.run }
    end

    it do
      login_user(user)
      visit gws_portal_user_path(site: site, user: user)

      # punch
      expect(page).to have_css('.today .info .enter', text: '--:--')
      within '.today .action .enter' do
        page.accept_confirm do
          page.accept_confirm do
            click_on I18n.t('gws/attendance.buttons.punch')
          end
        end
      end
      #expect(page).to have_css('#notice', text: I18n.t('gws/attendance.notice.punched'))
      expect(page).to have_css('.today .info .enter', text: format('%d:%02d', now.hour, now.min))

      expect(page).to have_css('.today .info .leave', text: '--:--')
      within '.today .action .leave' do
        page.accept_confirm do
          page.accept_confirm do
            click_on I18n.t('gws/attendance.buttons.punch')
          end
        end
      end
      #expect(page).to have_css('#notice', text: I18n.t('gws/attendance.notice.punched'))
      expect(page).to have_css('.today .info .leave', text: format('%d:%02d', now.hour, now.min))

      # edit
      within '.today .action .enter' do
        wait_cbox_open { click_on I18n.t('ss.buttons.edit') }
      end
      wait_for_cbox do
        select I18n.t("gws/attendance.hour", count: 8), from: 'cell[in_hour]'
        select I18n.t("gws/attendance.minute", count: 32), from: 'cell[in_minute]'
        fill_in 'cell[in_reason]', with: reason
        click_on I18n.t('ss.buttons.save')
      end
      expect(page).to have_css('.today .info .enter', text: '8:32')

      within '.today .action .leave' do
        wait_cbox_open { click_on I18n.t('ss.buttons.edit') }
      end
      wait_for_cbox do
        select I18n.t("gws/attendance.hour", count: 19), from: 'cell[in_hour]'
        select I18n.t("gws/attendance.minute", count: 57), from: 'cell[in_minute]'
        fill_in 'cell[in_reason]', with: reason
        click_on I18n.t('ss.buttons.save')
      end
      expect(page).to have_css('.today .info .leave', text: '19:57')

      wait_for_ajax
    end

    it do
      login_user(user)
      visit gws_portal_user_path(site: site, user: user)

      # edit
      expect(page).to have_css('.today .info .travel-cost', text: '')
      within '.today .action .travel-cost' do
        wait_cbox_open { click_on I18n.t('ss.buttons.edit') }
      end
      wait_for_cbox do
        fill_in 'record[travel_cost]', with: travel_cost
        click_on I18n.t('ss.buttons.save')
      end
      expect(page).to have_css('.today .info .travel-cost', text: travel_cost)

      expect(page).to have_no_css('.today .info .location')

      expect(page).to have_css('.today .info .night-shift', text: I18n.t("gws/gkan.options.night_shift.disabled"))
      within '.today .action .night-shift' do
        wait_cbox_open { click_on I18n.t('ss.buttons.edit') }
      end
      wait_for_cbox do
        select I18n.t("gws/gkan.options.night_shift.enabled"), from: "record[night_shift]"
        click_on I18n.t('ss.buttons.save')
      end
      expect(page).to have_css('.today .info .night-shift', text: I18n.t("gws/gkan.options.night_shift.enabled"))

      expect(page).to have_css('.today .info .memo', text: '')
      within '.today .action .memo' do
        wait_cbox_open { click_on I18n.t('ss.buttons.edit') }
      end
      wait_for_cbox do
        fill_in 'record[memo]', with: memo
        click_on I18n.t('ss.buttons.save')
      end
      expect(page).to have_css('.today .info .memo', text: memo)

      wait_for_ajax
    end
  end
end
