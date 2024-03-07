require 'spec_helper'

describe "gws_gkan_manage_attendance_time_cards", type: :feature, dbscope: :example, js: true do
  before { create_gkan }
  let!(:site) { gkan_site }
  let!(:user) { gkan_user("101") }
  let(:reason) { unique_id }
  let(:memo) { unique_id }
  let(:travel_cost) { 600 }
  let(:attendance_path) { gws_gkan_attendance_time_card_main_path site.id }
  let(:manage_path) { gws_gkan_manage_attendance_time_cards_path site.id }

  context "basic" do
    let(:now) { Time.zone.now.change(hour: 8, minute: 0) }
    around do |example|
      travel_to(now) { example.run }
    end

    def visit_manage_attendance
      login_user(user)
      visit attendance_path
      expect(page).to have_css('.today .info .enter', text: '--:--')

      visit manage_path
      within ".gws-gkan-yearly-table" do
        expect(page).to have_css("table td", text: user.long_name)
        expect(page).to have_link("#{now.month}#{I18n.t("datetime.prompts.month")}")
        click_on "#{now.month}#{I18n.t("datetime.prompts.month")}"
      end
      expect(page).to have_css("table.time-card")
    end

    context 'edit enter' do
      it do
        visit_manage_attendance

        # edit
        within "table.time-card" do
          within "tr.current" do
            first("td.enter").click
          end
        end
        within '.cell-toolbar' do
          wait_cbox_open { click_on I18n.t('ss.buttons.edit') }
        end
        wait_for_cbox do
          select I18n.t("gws/attendance.hour", count: 8), from: 'cell[in_hour]'
          select I18n.t("gws/attendance.minute", count: 32), from: 'cell[in_minute]'
          click_on I18n.t('ss.buttons.save')
        end

        within "#cboxLoadedContent form.cell-edit" do
          error = I18n.t(
            "errors.format",
            attribute: I18n.t("activemodel.attributes.gws/attendance/time_edit.in_reason"),
            message: I18n.t("errors.messages.blank")
          )
          expect(page).to have_css("#errorExplanation", text: error)
        end

        wait_for_cbox do
          select I18n.t("gws/attendance.hour", count: 8), from: 'cell[in_hour]'
          select I18n.t("gws/attendance.minute", count: 32), from: 'cell[in_minute]'
          fill_in 'cell[in_reason]', with: reason
          click_on I18n.t('ss.buttons.save')
        end
        expect(page).to have_css("tr.current td.enter", text: '8:32')
      end
    end

    context 'edit leave' do
      it do
        visit_manage_attendance

        # edit
        within "table.time-card" do
          within "tr.current" do
            first("td.leave").click
          end
        end
        within '.cell-toolbar' do
          wait_cbox_open { click_on I18n.t('ss.buttons.edit') }
        end
        wait_for_cbox do
          select I18n.t("gws/attendance.hour", count: 8), from: 'cell[in_hour]'
          select I18n.t("gws/attendance.minute", count: 32), from: 'cell[in_minute]'
          click_on I18n.t('ss.buttons.save')
        end

        within "#cboxLoadedContent form.cell-edit" do
          error = I18n.t(
            "errors.format",
            attribute: I18n.t("activemodel.attributes.gws/attendance/time_edit.in_reason"),
            message: I18n.t("errors.messages.blank")
          )
          expect(page).to have_css("#errorExplanation", text: error)
        end

        wait_for_cbox do
          select I18n.t("gws/attendance.hour", count: 8), from: 'cell[in_hour]'
          select I18n.t("gws/attendance.minute", count: 32), from: 'cell[in_minute]'
          fill_in 'cell[in_reason]', with: reason
          click_on I18n.t('ss.buttons.save')
        end
        expect(page).to have_css("tr.current td.leave", text: '8:32')
      end
    end

    context 'edit start' do
      it do
        visit_manage_attendance

        within "table.time-card" do
          within "tr.current" do
            first("td.start").click
          end
        end
        within '.cell-toolbar' do
          wait_cbox_open { click_on I18n.t('ss.buttons.edit') }
        end
        wait_for_cbox do
          select I18n.t("gws/attendance.hour", count: 8), from: 'cell[in_hour]'
          select I18n.t("gws/attendance.minute", count: 32), from: 'cell[in_minute]'
          click_on I18n.t('ss.buttons.save')
        end

        within "#cboxLoadedContent form.cell-edit" do
          error = I18n.t(
            "errors.format",
            attribute: I18n.t("activemodel.attributes.gws/attendance/time_edit.in_reason"),
            message: I18n.t("errors.messages.blank")
          )
          expect(page).to have_css("#errorExplanation", text: error)
        end

        wait_for_cbox do
          select I18n.t("gws/attendance.hour", count: 8), from: 'cell[in_hour]'
          select I18n.t("gws/attendance.minute", count: 32), from: 'cell[in_minute]'
          fill_in 'cell[in_reason]', with: reason
          click_on I18n.t('ss.buttons.save')
        end
        expect(page).to have_css("tr.current td.start", text: '8:32')
      end
    end

    context 'edit close' do
      it do
        visit_manage_attendance

        within "table.time-card" do
          within "tr.current" do
            first("td.close").click
          end
        end
        within '.cell-toolbar' do
          wait_cbox_open { click_on I18n.t('ss.buttons.edit') }
        end
        wait_for_cbox do
          select I18n.t("gws/attendance.hour", count: 8), from: 'cell[in_hour]'
          select I18n.t("gws/attendance.minute", count: 32), from: 'cell[in_minute]'
          click_on I18n.t('ss.buttons.save')
        end

        within "#cboxLoadedContent form.cell-edit" do
          error = I18n.t(
            "errors.format",
            attribute: I18n.t("activemodel.attributes.gws/attendance/time_edit.in_reason"),
            message: I18n.t("errors.messages.blank")
          )
          expect(page).to have_css("#errorExplanation", text: error)
        end

        wait_for_cbox do
          select I18n.t("gws/attendance.hour", count: 8), from: 'cell[in_hour]'
          select I18n.t("gws/attendance.minute", count: 32), from: 'cell[in_minute]'
          fill_in 'cell[in_reason]', with: reason
          click_on I18n.t('ss.buttons.save')
        end
        expect(page).to have_css("tr.current td.close", text: '8:32')
      end
    end

    context 'edit travel-cost' do
      it do
        visit_manage_attendance

        within "table.time-card" do
          within "tr.current" do
            first("td.travel-cost").click
          end
        end
        within '.cell-toolbar' do
          wait_cbox_open { click_on I18n.t('ss.buttons.edit') }
        end
        wait_for_cbox do
          fill_in 'record[travel_cost]', with: travel_cost
          click_on I18n.t('ss.buttons.save')
        end
        expect(page).to have_css('tr.current td.travel-cost', text: travel_cost)
      end
    end

    context 'edit location' do
      it do
        login_user(user)
        visit attendance_path

        expect(page).to have_no_css("table.time-card td.location")
        expect(page).to have_no_css("table.time-card td.location-cost")
      end
    end

    context 'edit night-shift' do
      it do
        visit_manage_attendance

        within "table.time-card" do
          within "tr.current" do
            first("td.night-shift").click
          end
        end
        within '.cell-toolbar' do
          wait_cbox_open { click_on I18n.t('ss.buttons.edit') }
        end
        wait_for_cbox do
          select I18n.t("gws/gkan.options.night_shift.enabled"), from: "record[night_shift]"
          click_on I18n.t('ss.buttons.save')
        end
        expect(page).to have_css('tr.current td.night-shift', text: I18n.t("gws/gkan.options.night_shift.enabled"))
      end
    end

    context 'edit memo' do
      context "edit in monthly table" do
        it do
          visit_manage_attendance

          within "table.time-card" do
            within "tr.current" do
              first("td.memo").click
            end
          end
          within '.cell-toolbar' do
            wait_cbox_open { click_on I18n.t('ss.buttons.edit') }
          end
          wait_for_cbox do
            fill_in 'record[memo]', with: memo
            click_on I18n.t('ss.buttons.save')
          end
          expect(page).to have_css('tr.current td.memo', text: memo)
        end
      end
    end
  end
end
