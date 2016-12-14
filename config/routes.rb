Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "check", to: "checker#check"
    end
  end

  root "api/v1/checker#check"
end
