class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy vote ]
  before_action :require_login, only: %i[ new create edit update destroy vote ]

  # GET /articles or /articles.json
  def index
    scope = Article.includes(:user)

    ordered = case params[:sort]
    when "relevant"
      scope.order(popularity: :desc, created_at: :desc)
    else
      scope.order(created_at: :desc)
    end

    @featured_article = ordered.first
    @articles = ordered.offset(1)
  end

  # GET /articles/1 or /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles or /articles.json
  def create
    @article = current_user.articles.build(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to user_article_path(@article.user.username, @article.slug), notice: "Publicação criada com sucesso." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @article.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to user_article_path(@article.user.username, @article.slug), notice: "Publicação atualizada com sucesso.", status: :see_other }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @article.errors, status: :unprocessable_content }
      end
    end
  end


  def vote
    if current_user == @article.user
      redirect_to user_article_path(@article.user.username, @article.slug),
        alert: "Você não pode votar na própria publicação.",
        status: :see_other
      return
    end

    success = @article.vote(
      params[:up] ? :up : :down,
      current_user
    )

    if success
      redirect_to user_article_path(@article.user.username, @article.slug),
        notice: "Voto registrado com sucesso.",
        status: :see_other
    else
      redirect_to user_article_path(@article.user.username, @article.slug),
        alert: "Você já registrou esse voto.",
        status: :see_other
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy!

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Publicação excluída com sucesso.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      user = User.find_by!(username: params[:username])

      slug = params[:slug] || params[:id]

      @article = user.articles.find_by!(slug: slug)
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.expect(article: [ :title, :body, :published, :popularity, :ref ])
    end
end
