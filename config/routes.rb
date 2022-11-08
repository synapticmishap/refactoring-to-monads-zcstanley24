Rails.application.routes.draw do
  resource :addresses, only: :edit
end
