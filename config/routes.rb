Rails.application.routes.draw do
  resources :users
  resources :overdue_students, only: [:index]
  resources  :books
  resources :students
  resources :bookmarks, only: [:index, :destroy, :create]
  resources :libraries
  resources :librarians
  resources :borrowed_histories, only: [:index, :create]
  resources :hold_requests, only: [:index, :destroy, :create]
  resources :requests, only: [:index, :destroy, :create, :update]
  resources :return_books, only: [:index]
  resources :book_histories, only: [:index]
  resources :student_requests, only: [:index]
  resources :checkedout_books, only: [:index]
  get 'auth/login' => 'auth#login'
  get 'auth/signup'
  post 'auth/create'
  post '/auth/authorize'
  post '/requests/approvals', to: 'requests#approvals'
  root 'auth#signup'
  get '/auth/destroy'
  post 'return_books/return' => 'return_books#return'
end
