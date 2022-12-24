class Admin::ItemsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @items = Item.page(params[:page]).per(10)
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id])
  end

  def edit_index
    @customer = Customer.find(params[:item_id])
    @items = @customer.items.latest.page(params[:page]).per(10)
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to admin_item_path(@item)
    else
      render 'edit'
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    redirect_to admin_items_path, notice: "投稿を削除しました！"
  end

  private

  def item_params
    params.require(:item).permit(:title, :body, :category, :star, :image, :is_published_flag, :is_admin_published_flag)
  end
end
