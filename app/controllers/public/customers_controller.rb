class Public::CustomersController < ApplicationController

  def show
    @customer = Customer.find(params[:id])
    #@books = @user.books
    #@book = Book.new
    #@today_book = @books.created_today
    #@yesterday_book = @books.created_yesterday
    #@this_week_book = @books.created_this_week
    #@last_week_book = @books.created_last_week
  end

  def index
    @customers = Customer.all
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
    @book = Book.new
    if params[:created_at] == ""
      @search_book = "日付を選択してください"
    else
      create_at = params[:created_at]
      @search_book = @books.where(['created_at LIKE ? ', "#{create_at}%"]).count
    end
  end

  private

  def user_params
    params.require(:customer).permit(:name, :introduction, :profile_image)
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

end
