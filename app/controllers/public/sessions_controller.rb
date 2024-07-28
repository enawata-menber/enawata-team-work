class Public::SessionsController < Devise::SessionsController
  #before_action :configure_sign_in_params, only: [:create]
  before_action :customer_state, only: [:create]
  # before_action :customer_state, except: [:create]
  # before_action :authenticate_customer!, except: [:top]
  
  def create
    super
  end
  
  
  protected

  def customer_state
    @customer = Customer.find_by(email: params[:customer][:email]) #入力されたemailからアカウントを1件取得
    return if @customer.nil? #アカウントを取得できなかった場合、このメソッドを終了
    return unless @customer.valid_password?(params[:customer][:password]) #取得したアカウントのパスワードと入力されたパスワードが一致していない場合、このメソッドを終了
    if @customer.is_active == false
      flash[:alert] = "退会済みです。再度、新規登録をお願いいたします。"
      redirect_to new_customer_registration_path
    end
  end
  
  def after_sign_in_path_for(resource)
     public_root_path
  end
  
  def after_sign_out_path_for(resource)
    public_root_path
  end

end


