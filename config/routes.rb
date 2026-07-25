Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#home"
  get "about" => "pages#about", as: :about
  get "agent" => "pages#agent", as: :agent
  get "services" => "pages#services", as: :services
  get "properties" => "pages#properties", as: :properties
  get "properties/autocomplete" => "pages#autocomplete_properties", as: :autocomplete_properties
  get "property/:id" => "pages#property", as: :property
  get "blog" => "pages#blog", as: :blog
  get "blog_post" => "pages#blog_post", as: :blog_post
  get "contact" => "pages#contact", as: :contact
  post "contact" => "pages#create_inquiry"
  post "inquiries" => "pages#create_inquiry", as: :create_inquiry
  post "reports" => "pages#create_report", as: :create_report

  # ─── Admin Namespace ─────────────────────────────────────────────
  namespace :admin do
    root "dashboard#index"

    # Properties — full CRUD + toggle actions
    resources :properties, only: [:index, :new, :create, :edit, :update, :destroy] do
      member do
        patch :toggle_featured
        patch :toggle_status
      end
    end

    # Users — list + quick status/role/verify updates
    resources :users, only: [:index, :update]

    # Cities — full CRUD
    resources :cities, only: [:index, :new, :create, :edit, :update, :destroy]

    # Inquiries — list + destroy
    resources :inquiries, only: [:index, :destroy]

    # Appointments — list + status update
    resources :appointments, only: [:index, :update]

    # Reports — list + status update + destroy
    resources :reports, only: [:index, :update, :destroy]
  end

  # Legacy admin route kept for backward-compat; redirect to new panel
  get "admin" => redirect("/admin"), as: :admin
  post "admin" => "pages#create_property", as: :create_property
end
