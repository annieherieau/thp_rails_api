class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show update destroy ]
  before_action :authenticate_user!, except: %i[ index]
  
  # GET /articles
  def index
    @articles = Article.all
    render json: @articles
  end

  # GET /articles/1
  def show
    if !@article.private || (@article.private && @article.user == current_user)
      render json: @article
    else
      render json: { message: "Cet article est privé." }, status: :unauthorized
    end
  end

  # POST /articles
  def create
    @article = Article.new(article_params)
    @article.user = current_user

    if @article.save
      render json: @article, status: :created, location: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/1
  def update
    # Author only
    set_article()
    if @article.user == current_user
      if @article.update(article_params)
        render json: @article
      else
        render json: @article.errors, status: :unprocessable_entity
      end
    else
      render json: { message: "Vous ne pouvez pas modifier cet article." }, status: :unauthorized
    end
  end

  # DELETE /articles/1
  def destroy
    # Author only
    set_article()
    if @article.user == current_user
      @article.destroy!
      render json: { message: "Article was successfully destroyed." }, status: :ok
      
    else
      render json: { message: "Vous ne pouvez pas supprimer cet article" }, status: :unauthorized
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :content, :private)
    end
end
