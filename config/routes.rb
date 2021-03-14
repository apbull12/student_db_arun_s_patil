Rails.application.routes.draw do
  devise_for :users
  root to: 'students#index'
  resources :students
  resources :institutions
  get 'user/students/registration' => 'users#new_student_registration',
      :as => 'user_student_registration'
  post 'user/students/registration/submit(/:query)' => 'users#send_request',
       :as => 'send_request'

  get '/pending_requests' => 'students#list_pending_request',
      :as => 'pending_requests'
  post '/accept_request/:id' => 'students#accept_student',
       :as => 'accept_student'
  get '/search(/:query)' => 'students#search', :as => 'search_page'
  get '/sort/s_name(:query)' => 'students#list_by_full_name'
  get '/sort/i_name(/:query)' => 'students#list_by_institution'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
