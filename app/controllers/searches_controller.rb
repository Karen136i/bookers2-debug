class SearchesController < ApplicationController
  def search
    @model = params[:model] #@model : 検索モデル（User、Bookから選択）
    @content = params[:content] #@content : 検索ワード（ユーザーが自由記述）
    @method = params[:method] #@method : 検索方法（前方一致、後方一致、部分一致、完全一致から選択）
    if @model == 'user'
      @records = User.search_for(@content, @method)
    else
      @records = Book.search_for(@content, @method)
    end
  end
end
