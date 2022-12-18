class Public::ItemsController < ApplicationController
  before_action :authenticate_customer!, only: [:create, :edit, :update, :destroy]

  def new
    @item = Item.new
  end

  def index
    if params[:latest]
      @items = Item.latest.published
    elsif params[:old]
      @items = Item.old.published
    elsif params[:star_count]
      @items = Item.star_count.published
    elsif params[:favorite_week]
    to  = Time.current.at_end_of_day
    from  = (to - 6.day).at_beginning_of_day
    @items = Item.includes(:favorited_customers).published
      .sort {|a,b|
      b.favorite.where(created_at: from...to).size <=>
      a.favorite.where(created_at: from...to).size
    }
    else
      @items = Item.published
    end
  end
  
  def edit_index
    
    
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
    params.require(:item).permit(:title, :body, :category, :star, :image, :is_published_flag)
  end

end
