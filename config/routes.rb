PhotoAlbums::Application.routes.draw do
  namespace :albums do
    get :inbox
  end
  resources :photos, only: [:index, :show]

  # FIXME: why do I need the index and show actions to respond_with a User?
  resources :users, only: [:index, :show] do
    collection do
      post :sign_in
    end
  end

  get 'privacy' => 'static_pages#privacy'

  root :to => 'assets#index'
end
