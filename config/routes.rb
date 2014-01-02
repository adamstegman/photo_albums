PhotoAlbums::Application.routes.draw do
  namespace :albums do
    get :inbox
  end

  root :to => 'assets#index'
end
