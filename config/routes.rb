# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'students#index'
  resources :students
  resources :institutions

  # To request student registration from the mail
  get 'user/students/registration' => 'users#new_student_registration',
      :as => 'user_student_registration'

  # To send a mail with requested email and URL
  post 'user/students/registration/submit(/:query)' => 'users#send_request',
       :as => 'send_request'

  # To list the pending requests
  get '/pending_requests' => 'students#list_pending_request',
      :as => 'pending_requests'

  # To Approve the Request
  post '/accept_request/:id' => 'students#accept_student',
       :as => 'accept_student'
  # To get the Student registration page
  get '/register' => 'students#registration', :as => 'registration_page'

  # To Search the student and institution based on the full name and name
  get '/search(/:query)' => 'students#search', :as => 'search_page'

  # To Sort based on the student full name
  get '/sort/s_name(:query)' => 'students#list_by_full_name'

  # To Sort Based on the institution name
  get '/sort/i_name(/:query)' => 'students#list_by_institution'
end
