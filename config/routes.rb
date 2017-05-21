Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :messages do
    post ':type', type: /#{Message.message_types.keys.join('|')}/, action: :create
  end

  root to: 'messages#index'
end
