class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!
  
  def show
    @customer = current_customer
  end
  
  def edit
    @customer = current_customer
  end
  
  def update
    @customer = current_customer
    @customer.update(customer_params)
    flash[:notice] = "変更内容を登録しました"
    redirect_to public_customer_my_page_path
  end
  
  def unsubscribe
    @customer = current_customer
  end
  
  def withdraw
    @customer = current_customer
    @customer.update(is_active: false)
    flash[:notice] = "ありがとうございました。またのご利用を心よりお待ちしております。"
    redirect_to public_root_path
    
  end
  
  
  private

  def customer_params
    params.require(:customer).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :email, :postal_code, :address, :telephone_number)
  end

end
