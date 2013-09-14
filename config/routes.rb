Orstrings::Application.routes.draw do

  resource :petition, :only => [:show] do
    resources :signatures,    :only        => [:index, :show, :new, :create],
                              :constraints => {:id => /\d+/}
    resources :invites,       :only        => [:show],
                              :constraints => {:id => /[a-f0-9]{32}/}
    resources :confirmations, :only        => [:show],
                              :path        => 'confs',
                              :constraints => {:id => /[a-f0-9]{32}/}
  end

  root :to => 'welcome#index'

end
