require 'spec_helper'

describe "gws_gkan_attendance_time_card", type: :feature, dbscope: :example, js: true do
  before { create_gkan }
  let!(:site) { gkan_site }
  let!(:user1) { gkan_user("105") }
  let!(:user2) { gkan_user("104") }
  let(:workflow_comment) { unique_id }
  let(:remand_comment1) { unique_id }

  let(:attendance_path) { gws_gkan_attendance_time_card_main_path site.id }
  let(:manage_path) { gws_gkan_manage_attendance_main_path site.id }

  context "basic" do
    it "#index" do
      login_user(user1)
      visit attendance_path
      within ".nav-operation" do
        click_on I18n.t("gws/gkan.buttons.workflow")
      end

      #
      # 申請する
      #
      within ".mod-workflow-request" do
        select I18n.t("mongoid.attributes.workflow/model/route.my_group"), from: "workflow_route"
        click_on I18n.t("workflow.buttons.select")
        wait_cbox_open { click_on I18n.t("workflow.search_approvers.index") }
      end
      wait_for_cbox do
        expect(page).to have_content(user2.long_name)
        find("tr[data-id=\"1,#{user2.id}\"] input[type=checkbox]").click
        click_on I18n.t("workflow.search_approvers.select")
      end
      within ".mod-workflow-request" do
        fill_in "workflow[comment]", with: workflow_comment
        click_on I18n.t("workflow.buttons.request")
      end
      expect(page).to have_css(".mod-workflow-view dd", text: I18n.t("workflow.state.request"))

      expect(Gws::Gkan::Attendance::TimeCard.all.count).to eq 1
      item = Gws::Gkan::Attendance::TimeCard.first

      expect(item.workflow_user_id).to eq user1.id
      expect(item.workflow_state).to eq 'request'
      expect(item.workflow_comment).to eq workflow_comment
      expect(item.workflow_approvers.count).to eq 1
      expect(item.workflow_approvers).to \
        include({level: 1, user_id: user2.id, editable: '', state: 'request', comment: ''})

      #
      # 申請を承認する
      #
      login_user(user2)
      visit manage_path
      click_on "[申請]#{Time.zone.today.month}月"

      within ".mod-workflow-approve" do
        fill_in "remand[comment]", with: remand_comment1
        click_on I18n.t("workflow.buttons.approve")
      end

      expect(page).to have_css(".mod-workflow-view dd", text: /#{::Regexp.escape(remand_comment1)}/)

      item.reload
      expect(item.workflow_user_id).to eq user1.id
      expect(item.workflow_state).to eq 'approve'
      expect(item.workflow_comment).to eq workflow_comment
      expect(item.workflow_approvers.count).to eq 1
      expect(item.workflow_approvers).to \
        include({level: 1, user_id: user2.id, editable: '', state: 'approve', comment: remand_comment1, file_ids: nil})
      expect(item.locked?).to be_truthy
    end
  end
end
