class Public::HomesController < ApplicationController
    
    def top
        @items = Item.where(is_active: true).order(created_at: "DESC").limit(4)
        @genres = Genre.all
        
        
    end
    
    def about
        
    end
end
