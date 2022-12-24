class Public::ItemCommentsController < ApplicationController
  before_action :authenticate!

  def create
    @item = Item.find(params[:item_id])
    comment = current_customer.item_comments.new(item_comment_params)
    comment.item_id = @item.id
    comment.save
    @item_comment = ItemComment.new
  end

  def destroy
    @item=Item.find(params[:item_id])
    @item_comment=ItemComment.find_by(id: params[:id], item_id: params[:item_id])
    @item_comment.destroy
    @item_comment = ItemComment.new
  end

  private

  def item_comment_params
    params.require(:item_comment).permit(:comment)
  end

end
