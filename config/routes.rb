NinetyNineCatsDay1::Application.routes.draw do
  resources :cats, except: :destroy do
    resources :cat_rental_requests, only: [:new]
  end

  resources :cat_rental_requests, only: [:create, :new] do
    post "approve", on: :member
    post "deny", on: :member
  end
  resource :user
  resource :session, only: [:new, :create, :destroy]

  root to: redirect("/cats")

end
