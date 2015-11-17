class ArticlesController < ApplicationController
  def new

  end

  def create
   # render plain: params[:article].inspect
    @article = Article.new(params [:params])
    @article.save
    redirect_to @article
  end
end
