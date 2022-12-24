class Admin::SearchesController < ApplicationController
    before_action :authenticate_admin!

  def search
      @items = Item.looks(params[:search], params[:word])
      @items = Kaminari.paginate_array(@items).page(params[:page]).per(10)
      render "admin/searches/result"
  end

  def customer_search
    @customers = Customer.looks(params[:search], params[:word]).page(params[:page]).per(10)
    render "admin/searches/customer_result"
  end

end
