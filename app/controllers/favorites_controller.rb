class FavoritesController < ApplicationController
  
  def index
    books = Book.all
    redirect_to books
  end
  
def create
  book = Book.find(params[:book_id])
  favorite = current_user.favorites.new(book_id: book.id)
  favorite.save
  redirect_to request.referer  #いいねを押したもしくは消したとき同じ画面に戻る方法
end

def destroy
  book = Book.find(params[:book_id])
  favorite = current_user.favorites.find_by(book_id: book.id)
  favorite.destroy
  redirect_to request.referer
end 

end 