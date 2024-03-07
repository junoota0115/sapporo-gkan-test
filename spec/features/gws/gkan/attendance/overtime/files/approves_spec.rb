require 'spec_helper'

describe "gws_gkan_attendance_overtime_files", type: :feature, dbscope: :example, js: true do
  context "approve file" do
    let!(:site) { gkan_site }
    let!(:user) { gkan_user("101") }
    let!(:item) { create :gws_gkan_attendance_overtime_file }
    let(:show_path) { gws_gkan_attendance_overtime_file_path site, item }
    let(:workflow_comment) { unique_id }
    let(:remand_comment1) { unique_id }

    #before do
    #  site.canonical_scheme = %w(http https).sample
    #  site.canonical_domain = "#{unique_id}.example.jp"
    #  site.save!
    #
    #  gws_user.notice_workflow_email_user_setting = "notify"
    #  gws_user.send_notice_mail_addresses = "#{unique_id}@example.jp"
    #  gws_user.save!
    #
    #  user1.notice_workflow_email_user_setting = "notify"
    #  user1.send_notice_mail_addresses = "#{unique_id}@example.jp"
    #  user1.save!
    #
    #  ActionMailer::Base.deliveries.clear
    #end
    #
    #after { ActionMailer::Base.deliveries.clear }

    it do
      login_user(user)
      visit show_path

      #
      # 申請する
      #
      within ".mod-workflow-request" do
        select I18n.t("mongoid.attributes.workflow/model/route.my_group"), from: "workflow_route"
        click_on I18n.t("workflow.buttons.select")
        wait_cbox_open { click_on I18n.t("workflow.search_approvers.index") }
      end
      wait_for_cbox do
        expect(page).to have_content(user.long_name)
        find("tr[data-id=\"1,#{user.id}\"] input[type=checkbox]").click
        click_on I18n.t("workflow.search_approvers.select")
      end
      within ".mod-workflow-request" do
        fill_in "workflow[comment]", with: workflow_comment
        click_on I18n.t("workflow.buttons.request")
      end
      expect(page).to have_css(".mod-workflow-view dd", text: I18n.t("workflow.state.request"))

      item.reload
      expect(item.workflow_user_id).to eq user.id
      expect(item.workflow_state).to eq 'request'
      expect(item.workflow_comment).to eq workflow_comment
      expect(item.workflow_approvers.count).to eq 1
      expect(item.workflow_approvers).to \
        include({level: 1, user_id: user.id, editable: '', state: 'request', comment: ''})

      #
      # 申請を承認する
      #
      login_user(user)
      visit show_path

      within ".mod-workflow-approve" do
        fill_in "remand[comment]", with: remand_comment1
        click_on I18n.t("workflow.buttons.approve")
      end

      expect(page).to have_css(".mod-workflow-view dd", text: /#{::Regexp.escape(remand_comment1)}/)

      item.reload
      expect(item.workflow_user_id).to eq user.id
      expect(item.workflow_state).to eq 'approve'
      expect(item.workflow_comment).to eq workflow_comment
      expect(item.workflow_approvers.count).to eq 1
      expect(item.workflow_approvers).to \
        include({level: 1, user_id: user.id, editable: '', state: 'approve', comment: remand_comment1, file_ids: nil})
    end
  end
end
