PhotoAlbums::Application.routes.draw do
  namespace :albums do
    get :inbox
  end
  resources :photos, only: [:create, :index, :show]

  # FIXME: why do I need the index and show actions to respond_with a User?
  resources :users, only: [:index, :show] do
    collection do
      post :sign_in
    end
  end
  resource :blob_session, only: [:show]

  root to: 'assets#index'
end
