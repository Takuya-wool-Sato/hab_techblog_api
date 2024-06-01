# app/controllers/articles_controller.rb
class ArticlesController < ApplicationController
  def index
    user_name = params[:name]
    keyword = params[:q]
    if user_name
      @articles = Article.where(name: user_name).order("pubDate DESC")
    else
      @articles = Article.all.order("pubDate DESC")
      @articles = @articles.where('title LIKE ? OR summary LIKE ?', "%#{keyword}%", "%#{keyword}%") if keyword.present?
    end
    render json: @articles
  end

  def show
    @article = Article.find(params[:id])
    render json: @article
  end
end
