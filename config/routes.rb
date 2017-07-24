Rails.application.routes.draw do

  root to: 'home#index'

  # oferta - outside
  get 'oferta' => 'home#index', as: :offer
  post 'nowe_konto' => 'home#create_user', as: :create_user
  get 'terms' => 'home#terms', as: :terms
  get 'privacy' => 'home#privacy', as: :privacy

  # get 'zaloguj_sie' => 'account#sign_in', as: :sign_in

  get 'konto' => 'account#index', as: :account_home
  get 'twoje_dane(/:pass)' => 'account#edit', as: :account_edit
  patch 'update' => 'account#update', as: :account_update
  patch 'password' => 'account#change_password', as: :account_change_password
  get 'faktury' => 'account#invoices', as: :account_invoices

  get 'konto' => 'account#index', as: :account

  devise_for :users, skip: [:registrations]

  resources :employees, except: [:show] do
    collection do
      get 'companies(/:page)' => 'employees#companies', as: :companies
      put 'assign' => 'employees#assign', as: :assign
    end
  end

  resources :companies, except: [:show] do
    collection do
      get 'import' => 'companies#import', as: :import
      get 'export' => 'companies#export', as: :export
      get 'uploaded' => 'companies#uploaded', as: :uploaded
      post 'upload' => 'companies#upload', as: :upload
    end
  end

  get '/zus' => 'zus#index', as: :zus
  post '/zus_save' => 'zus#save', as: :zus_save
  get '/zus_edit' => 'zus#edit', as: :zus_edit
  post '/zus_upload' => 'zus#upload', as: :zus_upload
  post '/zus_copy' => 'zus#copy', as: :zus_copy

  get 'podatki' => 'taxes#index', as: :taxes
  post 'save_taxes' => 'taxes#save', as: :save_taxes
  post 'upload_taxes' => 'taxes#upload', as: :upload_taxes

  get 'listy_plac' => 'payrolls#index', as: :payrolls
  post 'upload_payrolls(/:id)' => 'payrolls#upload', as: :upload_payrolls
  get 'download(/:id(/:pid))' => 'payrolls#download', as: :download_payrolls

  get 'urzedy' => 'tax_offices#index', as: :tax_offices
  get 'to_search(/:city)' => 'tax_offices#search', as: :tax_offices_search
  get 'to_show(/:id)' => 'tax_offices#show', as: :tax_offices_show

  get 'zus_render(/:token)' => 'renderers#zus', as: :zus_renderer
  get 'tax_render(/:token)' => 'renderers#tax', as: :tax_renderer
  get 'vat_render(/:token)' => 'renderers#vat', as: :vat_renderer
  get 'mail_render(/:token)' => 'renderers#mail', as: :mail_renderer

end
