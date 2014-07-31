Rails.application.routes.draw do
  get 'assets/css/*file', to: 'assets#css', format: false
  get 'assets/js/*file', to: 'assets#js', format: false
  get 'assets/image/*file', to: 'assets#img', format: false
  get 'assets/font/*file', to: 'assets#font', format: false
end
