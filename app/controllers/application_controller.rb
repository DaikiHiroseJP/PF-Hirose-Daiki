class ApplicationController < ActionController::Base
  #before_action :authenticate_customer!, except: [:top, :about]
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    current_customer
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def authenticate!
    if [ current_admin, current_customer ].all? {|e| e.nil?}
      :authenticate_admin! ### カスタマーページの動作をadminでも出来るようにする。ただ、エラーが発生する場合もあるため多用はしないこと。items_commentで利用中。
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
