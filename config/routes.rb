Rails.application.routes.draw do
  post   'allot_number'   => 'phone_numbers#allot_number'
  post   'allot_custom_number'   => 'phone_numbers#allot_custom_number'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
