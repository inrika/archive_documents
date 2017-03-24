Rails.application.routes.draw do
  resources :document_types 
  resources :categories do
    resources :documents do
      collection do
        get :import_documents
      end
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
 root 'categories#index'
  resources :documents do
    collection do
      get :import_documents
      get :load_reference
    end
  end

end
