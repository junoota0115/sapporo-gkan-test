FactoryBot.define do
  factory :gws_workflow_route, class: Gws::Workflow::Route do
    name { unique_id }
    user_id { gws_user.id }
    approvers { [ { "level" => 1, "user_id" => gws_user.id } ] }
    required_counts { [ false, false, false, false, false ] }
  end
end
