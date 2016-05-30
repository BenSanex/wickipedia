class ArticlesController < ApplicationController
  include ApplicationHelper

 def show
    @article = Article.find(params[:id])
    unless @article.published
      authenticate_user!
    end

    @category = @article.category
    if request.xhr?
      render '_show_partial', layout: false
    end
  end

  def new
    authenticate_user!
    @article = Article.new
    @category = Category.new
    @categories = Category.all.map {|category| [category.name, category.id] }
  end

  def create
    authenticate_user!
    @article = Article.new(article_params)

    if @article.save
      redirect_to edit_article_path(@article.category, @article)
    else
      render 'new'
    end
  end

  def edit
    authenticate_user!

    @article = Article.find(params[:id])
    if @article.edits.last == nil
      @last_edit = ""
    else
      @last_edit = @article.edits.last.content
    end
    @edit = Edit.new

    if request.xhr?
      render '_edit_partial', layout: false
    end
  end

  def update
    authenticate_user!
    @article = Article.find(params[:id])
    @edit = Edit.new(edit_params.merge(article_id: params[:id], editor_id: session[:user_id]))
    @edit.find_differences(@article)
    if @edit.save
      redirect_to articles_path
    else
      render 'edit'
    end
  end

  def destroy
    redirect_unless_admin
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to root_path
  end


  def show_revisions
    @article = Article.find(params[:id])
    @edits = @article.edits
  end

  def publish
    authenticate_user!
    article = Article.find(params[:id])
    article.toggle_published

    redirect_to articles_path
  end

  def feature
    redirect_unless_admin
    article = Article.find(params[:id])
    if article.published
      article.toggle_featured
    else
      article.toggle_published
      article.toggle_featured
    end
    redirect_to articles_path
  end

  private

  def article_params
    params.require(:article).permit(:title, :category_id)
  end

  def edit_params
    params.require(:edit).permit(:content)
  end
end
