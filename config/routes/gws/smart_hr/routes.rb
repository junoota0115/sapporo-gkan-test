Rails.application.routes.draw do
  Gws::SmartHr::Initializer

  gws "smart_hr" do
    get "/" => redirect { |p, req| "#{req.path}/groups" }, as: :main
    get 'groups' => "groups#index"
    post "groups/run" => "groups#run"
    get 'users' => "users#index"
    post "users/run" => "users#run"
    resource :setting, only: [:show]
  end
end
