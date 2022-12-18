class Public::SearchesController < ApplicationController
  before_action :authenticate_customer!

  def search
    #@range = params[:range]

    #if @range == "User"
      #@customers = Customer.looks(params[:search], params[:word])
      #render "public/searches/result"
    #else
      @items = Item.looks(params[:search], params[:word])
      render "public/searches/result"
    #end
  end
end
