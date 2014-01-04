PhotoAlbums::Application.routes.draw do
  namespace :albums do
    get :inbox
  end
  resources :photos, only: [:index, :show]

  root :to => 'assets#index'
end
