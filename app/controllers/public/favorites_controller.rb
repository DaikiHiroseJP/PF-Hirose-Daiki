class Public::FavoritesController < ApplicationController
  def create
    Favorite.create(favorite_params)
    @item = Item.find(params[:item_id])
  end

  def destroy
    if favorite = Favorite.find_by(favorite_params)
      favorite.destroy
    end
    @item = Item.find(params[:item_id])
  end

  private
  def favorite_params
    { item_id: params[:item_id], customer_id: current_customer.id }
  end
end
