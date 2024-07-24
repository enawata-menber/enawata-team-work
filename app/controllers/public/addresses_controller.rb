class Public::AddressesController < ApplicationController
  before_action :authenticate_customer!
  
  def index
    @addresses = current_customer.addresses
    @address = Address.new
  end
  
  def edit
    @address = Address.find(params[:id])
  end
  
  def create
    @address = Address.new(address_params)
    @address.customer_id = current_customer.id
    if @address.save
      flash[:notice] = "新規配送先を登録しました"
      redirect_to public_addresses_path
    else
      @addresses = current_customer.addresses
      render :index
    end
  end
  
  def update
    @address = Address.find(params[:id])
    if @address.update(address_params)
       flash[:success] = "変更内容を登録しました"
       redirect_to public_addresses_path
    else
       render :edit
    end
  end
  
  def destroy
    address = Address.find(params[:id])
    address = address.destroy
    flash[:alert] = "配送先を削除しました"
    redirect_to public_addresses_path
  end
  
  private

  def address_params
    params.require(:address).permit(:postal_code, :address, :name)
  end
  
  
end
