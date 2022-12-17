class Public::ItemsController < ApplicationController

  def new
    @item = Item.new
  end

  def index

    @items = Item.all


  end

  def show
    @item = Item.find(params[:id])
    @customer = Customer.find_by(id: @item.customer_id)
    @item_comment = ItemComment.new
    @item_detail = Item.find(params[:id])
    #unless ViewCount.find_by(customer_id: current_customer.id, item_id: @item_detail.id)
      #current_customer.view_counts.create(item_id: @item_detail.id)
    #end
  end

  def create
    @item = Item.new(item_params)
    @item.customer_id = current_customer.id
    if @item.save
      redirect_to item_path(@item), notice: "投稿に成功しました！"
    else
      @items = Item.all
      render 'index'
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to item_path(@item), notice: "You have updated item successfully."
    else
      render "edit"
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    redirect_to items_path
  end

  def search_item
    @items = Item.search(params[:keyword])

  end

  private

  def item_params
    params.require(:item).permit(:title, :body, :category, :star, :image)
  end

end
