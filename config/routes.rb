Rails.application.routes.draw do
  devise_for :users
  root to: 'students#index'
  resources :students
  resources :institutions
  get '/search(/:query)' => 'students#search', :as => 'search_page'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
