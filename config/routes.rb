Rails.application.routes.draw do
  

#ここから記載（たま）  
  # 顧客用
  # URL /customers/sign_in ...
  devise_for :customers,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  
  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }
  
  #Public routes
  #public/homes
  namespace :public do 
    root to: 'homes#top'
    get '/about', to: 'homes#about'
    #public/items
    resources :items, only: [:index, :show]
    #public/registrations
    # get '/customers/sign_up', to: 'registrations#new'
    # post '/customers', to: 'registrations#create'
    # #public/sessions
    # get '/customers/sign_in', to: 'sessions#new',as: 'new_customer_session'
    # post '/customers/sign_in', to: 'sessions#create',as: 'customer_session'
    # delete '/customers/sign_out',to: 'sessions#destroy',as: 'destroy_customer_session'
    # #public/customers
    # get '/custommers/my_page', to: 'customers#show', as: 'customer_my_page'
    # get '//customers/information/edit', to: 'customers#edit', as: 'edit_customer_information'
    # patch '/customers/information', to: 'customers#update', as:  'update_customer_information'
    # get '/customers/unsubscribe', to: 'customers#unsubscribe',as: 'customer_unsubscribe'
    # patch '/customers/withdraw',to: 'customers#withdraw', as: 'customer_withdraw'
    
    #public/cart_items
    resources :cart_items, only: [:index, :update, :destroy, :create]do
      collection do
        delete 'destroy_all', to: 'cart_items#destroy_all', as: 'destroy_all'
      end
    end
    #public/orders
    resources :orders, only: [:new, :create, :index, :show] do
      collection do
        post 'confirm', to: 'orders#confirm', as: 'confirm'
        get 'thanks', to: 'orders#thanks', as: 'thanks'
      end
    end
    #public/addresses
    resources :addresses, only: [:index, :edit, :create, :update, :destroy]
  end
  
  #Admin routes
  #admin/sessions
    namespace :admin do
    resource :session, only: [:new, :create, :destroy], controller: 'sessions' do
      collection do
        get 'sign_in', action: :new
        post 'sign_in', action: :create
        delete 'sign_out', action: :destroy
      end
    end
    #admin/homes
    root to: 'admin/homes#top'
    #admin/items
    resources :items
    #admin/genres
    resources :genres, only: [:index, :create, :edit, :update]
    #admin/customers
    resources :customers, only: [:index, :show, :edit, :update]
    #admin/orders
    resources :orders, only: [:show, :update]
    #admin/order_details
    resources :order_details, only: [:update]
end
end
