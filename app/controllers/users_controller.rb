class UsersController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id]) #showページ用にレコードからユーザー1人1人の情報を取得する必要があるため、findメソッドを使用
    @books = @user.books
    @users = User.all

    # DM 機能実装
    @current_entry = Entry.where(user_id: current_user.id)
    #roomがcreateされた際、ログインしているユーザーをEntriesテーブルに記録するためにwhereメソッドでcurrent_user.idを探す
    @another_entry = Entry.where(user_id: @user.id)
    #roomがcreateされた際、「DMを送る」ボタンを押された側のユーザーをEntriesテーブルに記録するためにwhereメソッドでuser.idを探す
    unless @user.id == current_user.id
    #unlessを使用することでroomsが作成されている場合とされていない場合に条件分岐させる
      @current_entry.each do |current|
      #作成済みであれば、「@current_entry」と「@another_entry」をeachで一つずつ取り出し、それぞれEntriesテーブル内にあるroom_idが共通しているユーザー同士に対して「@room_id = current.room_id」という変数を指定
        @another_entry.each do |another|
          if current.room_id == another.room_id then
            #ここで、すでに作成されているroom_idを特定することができる
            @is_room = true
            #「@is_room = true」は、これがfalseであるとき、else以降で新たにroomを作成する
            @room_id = current.room_id
          end
        end
      end
      if @is_room
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
    @book = Book.new
    @books = @user.books
  end

  def index
    @users = User.all
    @user = current_user
  end

  def edit
    @user =  User.find(params[:id])
  end

  def update
    @user =  User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "You have updated user successfully." #▲パスのちがい
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def is_matching_login_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
