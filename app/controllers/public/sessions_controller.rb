class Public::SessionsController < Devise::SessionsController
  #before_action :configure_sign_in_params, only: [:create]
  before_action :customer_state, only: [:create]
  # before_action :customer_state, except: [:create]
  # before_action :authenticate_customer!, except: [:top]
  
  def create
    super
  end
  
  
  protected
  # def customer_state
   
  #   @customer = Customer.find_by(email: params[:customer][:email]) #入力されたemailからアカウントを1件取得
  #   return if @customer.nil? #アカウントを取得できなかった場合、このメソッドを終了
  #   return unless @customer.valid_password?(params[:customer][:password]) #取得したアカウントのパスワードと入力されたパスワードが一致していない場合、このメソッドを終了
  #   if @customer.is_active == false 
  #     redirect_to new_customer_session_path
  #   end
  # end
  
  def customer_state
    @customer = Customer.find_by(email: params[:customer][:email]) #入力されたemailからアカウントを1件取得
    return if @customer.nil? #アカウントを取得できなかった場合、このメソッドを終了
    return unless @customer.valid_password?(params[:customer][:password]) #取得したアカウントのパスワードと入力されたパスワードが一致していない場合、このメソッドを終了
    if @customer.is_active == false 
      redirect_to public_root_path
    end
  end
  
  def after_sign_in_path_for(resource)
     public_root_path
  end
  
  def after_sign_out_path_for(resource)
    public_root_path
  end

  
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :encrypted_password])
  # end
end

    # if @customer.active_for_authentication? == true #アカウントがactiveだったら
    #   return # ここでcustomer_stateメソッドの実行を終了し、createアクションを実行
    # end
    #   redirect_to public_root_path #ここでサインアップ画面への遷移処理を実行
