class RoomsController < ApplicationController
   before_action :authenticate_user!

  def create
    @room = Room.create(user_id: current_user.id)
    # users/show.html.erbの「<%= form_for @room do |f| %>」で送られてきたパラメータを受け取り、createさせる
    # また、このcreateメソッドではRoom以外にその子モデルのEntryもcreateさせる必要があるため、Entriesテーブルに入る相互フォロー同士のユーザーを保存させるための記述をする
    @current_entry = Entry.create(user_id: current_user.id, room_id: @room.id)
    # ログイン中のユーザーに対しては「@current_entry」とし、EntriesテーブルにRoom.createで作成された@roomにひもづくidと、ログイン中のユーザーのidを保存させる記述をする
    @another_entry = Entry.create(params.require(:entry).permit(:user_id, :room_id).merge(:room_id => @room.id))
    # フォローされている側のユーザーは「@another_entry」とする。users/show.html.erbの「fields_for @entry」で保存した
    # paramsの情報(:user_id, :room_id)を許可し、ログイン中のユーザーと同じく@roomにひもづくidを保存する記述をする
    redirect_to room_path(@room)
    # そしてcreateと同時にチャットルームが開くようにredirectをする
  end

  def show
    @room = Room.find(params[:id])
    # roomsのshowアクションでは、まず1つのチャットルームを表示させる必要があるため、findメソッドを使う
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      # Entriesテーブルにログイン中のユーザーのidと、それにひもづいたチャットルームのidをwhereメソッドで探し、そのレコードがあるかを確認する
      # 条件がfalseだった場合、redirect_backで前のページに戻る
      @messages = @room.messages
      # 条件がtrueだった場合、Messagesテーブルにそのチャットルームのidとひもづいたメッセージを表示させるために
      # @messagesにアソシエーションを利用した「@room.messages」という記述を代入する
      @message = Message.new
      # 新しくメッセージを作成する場合、メッセージのインスタンスを生成するためにMessage.newで「@message」に代入する
      @entries = @room.entries
      # @room.entriesを@entriesというインスタンス変数に入れ、Entriesテーブルのuser_idの情報を取得
      @my_account = current_user.id
      # 「@my_account = current_user.id」はチャットルームで「〇〇さんとのメッセージ」と相手の名前を表示させるための記述
    else
      redirect_back(fallback_location: root_path)
    end
  end
end
