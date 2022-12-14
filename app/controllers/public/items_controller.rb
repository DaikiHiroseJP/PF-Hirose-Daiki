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
    #@item_comment = ItemComment.new
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

  private

  def item_params
    params.require(:item).permit(:title, :body, :category, :star, :image)
  end

end
