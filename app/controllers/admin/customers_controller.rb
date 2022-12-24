class Admin::CustomersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @customers = Customer.page(params[:page]).per(10)
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      flash[:notice] ="変更が反映されました。"
      redirect_to admin_customer_path(@customer)
    else
      render "edit"
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :email, :is_deleted, )
  end
end
