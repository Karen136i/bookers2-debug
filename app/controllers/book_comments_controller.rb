class BookCommentsController < ApplicationController

  def create
    book = Book.find(params[:book_id])
    comment = current_user.book_comments.new(book_comment_params)
    comment.book = book
    comment.save
    redirect_to request.referer
  end

  def show
    @book = Book.find(params[:book_id])
    @book_comment = BookComent.new
  end

  def destroy
    @comment = BookComment.find(params[:id])
    @comment.destroy
    redirect_to request.referer
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

end
