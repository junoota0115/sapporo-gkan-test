Rails.application.routes.draw do
  Gws::Gkan::Initializer

  concern :deletion do
    get :delete, on: :member
    delete :destroy_all, on: :collection, path: ''
  end

  concern :workflow do
    post :request_update, on: :member
    post :approve_update, on: :member
    post :remand_update, on: :member
    post :pull_up_update, on: :member
    post :restart_update, on: :member
    post :seen_update, on: :member
    match :request_cancel, on: :member, via: [:get, :post]
  end

  gws "gkan" do
    get "/" => "main#index", as: :main

    # attendance
    namespace "attendance" do
      get '/' => "main#index", as: :main

      # time_cards
      get '/time_cards/' => "main#index", as: :time_card_main
      resources :time_cards, path: 'time_cards/:year_month', only: %i[index] do
        match :download, on: :collection, via: %i[get post]
        get :print, on: :collection
        post :enter, on: :collection
        post :leave, on: :collection
        post :leave, path: 'leave:date', on: :collection
        match :detail, path: ':day/detail', on: :collection, via: %i[get post]
        match :memo, path: ':day/memo', on: :collection, via: %i[get post]
        match :travel_cost, path: ':day/travel_cost', on: :collection, via: %i[get post]
        match :overtime_files, path: ':day/over_time_files', on: :collection, via: %i[get post]
        get :leave_files, path: ':day/leave_files', on: :collection
        match :location, path: ':day/location', on: :collection, via: %i[get post]
        match :night_shift, path: ':day/night_shift', on: :collection, via: %i[get post]
        match :time, path: ':day/:type', on: :collection, via: %i[get post]
      end
      # time_card workflow
      namespace "time_card", path: 'time_card/:year_month' do
        resources :files, only: :show, concerns: [:deletion, :workflow]
        get "/search_approvers" => "search_approvers#index", as: :search_approvers
        match "/wizard/:id/approver_setting" => "wizard#approver_setting", via: [:get, :post], as: :approver_setting
        get "/wizard/:id/reroute" => "wizard#reroute", as: :reroute
        post "/wizard/:id/reroute" => "wizard#do_reroute", as: :do_reroute
        get "/wizard/:id/approveByDelegatee" => "wizard#approve_by_delegatee", as: "approve_by_delegatee"
        match "/wizard/:id" => "wizard#index", via: [:get, :post], as: :wizard
      end

      # setting
      resource :setting, only: [:show, :edit, :update]

      # locations
      resources :locations, concerns: [:deletion]

      # overtime
      namespace "overtime" do
        get '/' => "main#index", as: :main
        resources :files, path: 'files/:state', defaults: { state: 'mine' }, concerns: [:deletion, :workflow]
        get "/search_approvers" => "search_approvers#index", as: :search_approvers
        match "/wizard/:id/approver_setting" => "wizard#approver_setting", via: [:get, :post], as: :approver_setting
        get "/wizard/:id/reroute" => "wizard#reroute", as: :reroute
        post "/wizard/:id/reroute" => "wizard#do_reroute", as: :do_reroute
        get "/wizard/:id/approveByDelegatee" => "wizard#approve_by_delegatee", as: "approve_by_delegatee"
        match "/wizard/:id" => "wizard#index", via: [:get, :post], as: :wizard
      end

      # holiday work
      namespace "holiday_work" do
        get '/' => "main#index", as: :main
        resources :files, path: 'files/:state', defaults: { state: 'mine' }, concerns: [:deletion, :workflow]
        get "/search_approvers" => "search_approvers#index", as: :search_approvers
        match "/wizard/:id/approver_setting" => "wizard#approver_setting", via: [:get, :post], as: :approver_setting
        get "/wizard/:id/reroute" => "wizard#reroute", as: :reroute
        post "/wizard/:id/reroute" => "wizard#do_reroute", as: :do_reroute
        get "/wizard/:id/approveByDelegatee" => "wizard#approve_by_delegatee", as: "approve_by_delegatee"
        match "/wizard/:id" => "wizard#index", via: [:get, :post], as: :wizard
      end

      # leaves
      namespace "leave" do
        get '/main' => "main#index", as: :main
        resources :files, path: 'files/:state', defaults: { state: 'mine' }, concerns: [:deletion, :workflow]
        get "/search_approvers" => "search_approvers#index", as: :search_approvers
        match "/wizard/:id/approver_setting" => "wizard#approver_setting", via: [:get, :post], as: :approver_setting
        get "/wizard/:id/reroute" => "wizard#reroute", as: :reroute
        post "/wizard/:id/reroute" => "wizard#do_reroute", as: :do_reroute
        get "/wizard/:id/approveByDelegatee" => "wizard#approve_by_delegatee", as: "approve_by_delegatee"
        match "/wizard/:id" => "wizard#index", via: [:get, :post], as: :wizard
      end

      # works
      namespace "work" do
        get '/main' => "main#index", as: :main
        scope(path: ':fiscal_year', defaults: { fiscal_year: '-' }) do
          get "work_days" => "work_days#index"
          get "leave_taken" => "leave_taken#index"
          get "leave_left" => "leave_left#index"
        end
      end
    end

    # workflow
    namespace "workflow" do
      resources :routes, concerns: %i[deletion]
    end

    # manage
    namespace "manage" do
      namespace "attendance" do
        get '/' => "main#index", as: :main
        scope(path: ':fiscal_year/:group', defaults: { fiscal_year: '-', group: '-' }) do
          resources :time_cards, except: %i[new create edit update], concerns: [:deletion, :workflow] do
            match :detail, path: ':day/detail', on: :member, via: %i[get post]
            match :memo, path: ':day/memo', on: :member, via: %i[get post]
            match :travel_cost, path: ':day/travel_cost', on: :member, via: %i[get post]
            match :location, path: ':day/location', on: :member, via: %i[get post]
            match :night_shift, path: ':day/night_shift', on: :member, via: %i[get post]
            match :time, path: ':day/:type', on: :member, via: %i[get post]
            match :download, on: :member, via: %i[get post]
          end
        end

        match "default_records" => "default_records#index", via: [:get, :post]
        get "default_records/download_template" => "default_records#download_template"

        namespace "work_records" do
          get '/' => redirect { |p, req| "#{req.path}/download" }, as: :main
          match "download" => "download#index", via: [:get, :post]
          match "import" => "import#index", via: [:get, :post]
        end
      end

      namespace "work" do
        get '/' => "main#index", as: :main
        scope(path: ':fiscal_year', defaults: { fiscal_year: '-' }) do
          get "members" => "members#index"
          get "work_days" => "work_days#index"
          get "work_times" => "work_times#index"
          get "work_limits/:year_month/:limit_term" => "work_limits#index", defaults: { year_month: '-', limit_term: '-' }, as: :work_limits
          match "work_records" => "work_records#index", via: [:get, :post]
        end
      end

      namespace "payment" do
        get '/' => "main#index", as: :main
        namespace "internal" do
          get '/' => "main#index", as: :main
          match "overtime" => "overtime#index", via: [:get, :post]
          match "parttime" => "parttime#index", via: [:get, :post]
        end
        namespace "external" do
          get '/' => "main#index", as: :main
          match "regular21g" => "regular21g#index", via: [:get, :post]
          match "regular13g" => "regular13g#index", via: [:get, :post]
          match "parttime" => "parttime#index", via: [:get, :post]
        end
        match "audit" => "audit#index", via: [:get, :post]
      end
    end

    # admin
    namespace "admin" do
      get '/' => "main#index", as: :main

      # attendance_settings
      resources :users, only: [:index] do
        resources :attendance_settings, concerns: [:deletion] do
          resources :paid_leave, only: [:new, :create, :edit, :update, :destroy], concerns: [:deletion]
        end
        get :download, on: :collection
        match :import, on: :collection, via: %i[get post]
        match :import_paid_leave, on: :collection, via: %i[get post]
      end

      # duty_settings
      resources :duty_settings, concerns: [:deletion]

      # leave_settings
      resources :leave_settings, concerns: [:deletion] do
        resources :leave_units, only: [:new, :create, :edit, :update, :destroy], concerns: [:deletion]
      end

      # leave
      resources :leave, concerns: [:deletion]

      # rates
      resources :rates, concerns: [:deletion]
    end

    namespace 'apis' do
      get 'duty_settings' => 'duty_settings#index'
      get 'users' => 'users#index'
    end
  end
end
