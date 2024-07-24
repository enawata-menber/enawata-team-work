class ApplicationController < ActionController::Base
  # ヘッダーの切替用
    before_action :set_header


  private

  def set_header
    if admin_signed_in?
      @header = 'admin'
    elsif customer_signed_in?
      @header = 'public'
    else
      @header = 'guest'
    end
  end
  
end

