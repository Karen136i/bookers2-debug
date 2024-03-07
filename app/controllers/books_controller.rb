class BooksController < ApplicationController
before_action :is_matching_login_user, only: [:edit, :update]

  def show
    @book = Book.find(params[:id])
    # 閲覧数の表示
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book.id)
      # 一度閲覧したユーザーを数えたくないので↑のを使う
      current_user.view_counts.create(book_id: @book.id)
    end
    # ここまで
    @user = @book.user
    @users = User.all
    @comment = @book.book_comments.build
  end

  def index
    @book = Book.new
    @books = Book.all
    @users = @books
    @user = current_user
    @errors = flash.now[:error]
    @book_comment = BookComment.new
    @books = Book.includes(:user, :favorites)
               .where(created_at: 1.week.ago..Time.current)
               .sort_by { |book| -book.favorites.count }
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      @users = @books
      @user = current_user
      flash.now[:error] = @book.errors.full_messages
      render :index
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path(@book.id)
    else
      flash[:error] = @book.errors.full_messages
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_url, notice: "Book was successfully destroyed."
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :image)
  end

  def is_matching_login_user
    book = Book.find(params[:id])
    unless book.user.id == current_user.id
      redirect_to books_path
    end
  end
end
