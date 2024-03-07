FactoryBot.define do
  factory :workflow_route, class: Workflow::Route do
    name { unique_id }
    user_id { cms_user.id }
    approvers { [ { "level" => 1, "user_id" => cms_user.id } ] }
    required_counts { [ false, false, false, false, false ] }
  end
end
