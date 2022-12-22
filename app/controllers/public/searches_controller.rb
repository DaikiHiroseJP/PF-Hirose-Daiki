class Public::SearchesController < ApplicationController
  before_action :authenticate_customer!

  def search
      @items = Item.looks(params[:search], params[:word])
      render "public/searches/result"
  end

  def customer_search
    @customers = Customer.looks(params[:search], params[:word])
    render "public/searches/customer_result"
  end

end
