class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_user, only: [:followings, :followers]

  def show
    @customer = Customer.find(params[:id])
    @items = @customer.items.latest.published.admin_published.page(params[:page]).per(12)
  end

  def index
    @customers = Customer.undeleted
  end

  def edit
    is_matching_login_user
    @user = Customer.find(params[:id])
  end

  def update
    is_matching_login_user
    @user = Customer.find(params[:id])
    if @user.update(user_params)
      flash[:notice] ="変更が反映されました。"
      redirect_to customer_path(@user)
    else
      render :edit
    end
  end

  def followings
    @customers = @customer.followings
  end

  def followers
    @customers = @customer.followers
  end

  def search
    @customer = customer.find(params[:user_id])
    @customers = @customer.items
    if params[:created_at] == ""
      @search_book = "日付を選択してください"
    else
      create_at = params[:created_at]
      @search_book = @books.where(['created_at LIKE ? ', "#{create_at}%"]).count
    end
  end

  def unsubscribe
  end

  def withdraw
    @customer = current_customer
    @customer.update(is_deleted: true)
    reset_session
    redirect_to root_path
  end


  private

  def user_params
    params.require(:customer).permit(:name, :introduction, :profile_image, :is_deleted)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def is_matching_login_user
    customer_id = params[:id].to_i
    login_customer_id = current_customer.id
    if(customer_id != login_customer_id)
      redirect_to current_customer
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def reject_user
    @customer = Customer.find_by(name: params[:customer][:first_name][:last_name])
    if @customer
      if @customer.valid_password?(params[:customer][:encrypted_password]) && (@customer.is_deleted == false)
        redirect_to new_customer_registration
      end
    end
  end

end
