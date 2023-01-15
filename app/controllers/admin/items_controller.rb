class Admin::ItemsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @items = Item.page(params[:page]).per(10)
    @tag_list = Tag.all
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id])
    @tag_list = @item.tags.map { |tag| tag.name }
  end

  def edit_index
    @customer = Customer.find(params[:item_id])
    @items = @customer.items.latest.page(params[:page]).per(10)
  end

  def update
    @item = Item.find(params[:id])
    tag_list = params[:item][:name].split(/[[:blank:]]+/).select(&:present?)
    if @item.update(item_params)
      @item.update_tags(tag_list)
      redirect_to admin_item_path(@item), notice: "更新に成功しました！"
    else
      render 'edit'
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    redirect_to admin_items_path, notice: "投稿を削除しました！"
  end

  def search_item
    @tag_list = Tag.all
    @tag = Tag.find(params[:tag_id])
    @items = @tag.items.published.admin_published.page(params[:page]).per(10)
  end

  private

  def item_params
    params.require(:item).permit(:title, :body, :category, :star, :image, :is_published_flag, :is_admin_published_flag)
  end
end
