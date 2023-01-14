class Public::ItemsController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_user, only: [:edit, :update, :destroy]

  def new
    @item = Item.new
  end

  def index
    @items = Item.latest.published.admin_published.page(params[:page]).per(12)
    @tag_list = Tag.all
  end

  def edit_index
    is_matching_login_user
    @customer = Customer.find(params[:item_id])
    @items = @customer.items.latest.page(params[:page]).per(10)
  end

  def show
    if Item.find(params[:id]).is_admin_published_flag == false
      redirect_to items_path, notice: "管理者によって非公開にされています。"
    elsif Item.find(params[:id]).is_published_flag == false
      redirect_to items_path, notice: "ユーザーによって非公開にされています。"
    else
    @item = Item.find(params[:id])
    @customer = Customer.find_by(id: @item.customer_id)
    @item_comment = ItemComment.new
    @item_tags = @item.tags
    @item_detail = Item.find(params[:id])
    #unless ViewCount.find_by(customer_id: current_customer.id, item_id: @item_detail.id)
      #current_customer.view_counts.create(item_id: @item_detail.id)
    end
  end

  def create
    @item = Item.new(item_params)
    @item.customer_id = current_customer.id
    tag_list=params[:item][:name].split(',')
    if @item.save
      @item.save_tag(tag_list)
      redirect_to item_edit_index_path(current_customer), notice: "投稿に成功しました！"
    else
      render 'new'
    end
  end

  def edit
    @item = Item.find(params[:id])
    @tag_list = @item.tags.pluck(:name).join(',')
  end

  def update
    @item = Item.find(params[:id])
    tag_list = params[:item][:name].split(',')
    if @item.update(item_params)
      @old_relations = ItemTag.where(item_id: @item.id)
      @old_relations.each do |relation|
      relation.delete
      end
      @item.save_tag(tag_list)
      redirect_to item_edit_index_path(current_customer), notice: "更新に成功しました！"
    else
      render "edit"
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    redirect_to item_edit_index_path(current_customer), notice: "投稿を削除しました！"
  end

  def search_item
    @tag_list = Tag.all
    @tag = Tag.find(params[:tag_id])
    @items = @tag.items.published.admin_published.page(params[:page]).per(10)
  end

  private

  def item_params
    params.require(:item).permit(:title, :body, :category, :star, :image, :is_published_flag)
  end

  def ensure_user
    @items = current_customer.items
    @item = @items.find_by(id: params[:id])
    redirect_to items_path unless @item
  end

  def is_matching_login_user
    customer_id = params[:item_id].to_i
    login_customer_id = current_customer.id
    if(customer_id != login_customer_id)
      redirect_to current_customer
    end
  end

end
