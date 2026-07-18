Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#home"
  get "about" => "pages#about", as: :about
  get "agent" => "pages#agent", as: :agent
  get "services" => "pages#services", as: :services
  get "properties" => "pages#properties", as: :properties
  get "property/:id" => "pages#property", as: :property
  get "blog" => "pages#blog", as: :blog
  get "admin" => "pages#admin", as: :admin
  post "admin" => "pages#create_property", as: :create_property
  get "blog_post" => "pages#blog_post", as: :blog_post
  get "contact" => "pages#contact", as: :contact
end
