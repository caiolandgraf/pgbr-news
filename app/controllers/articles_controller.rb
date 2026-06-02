class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy vote create_comment vote_comment create_comment_comment vote_comment_comment destroy_comment ]
  before_action :require_login, only: %i[ new create edit update destroy vote create_comment create_comment_comment vote_comment vote_comment_comment ]

  # GET /
  def index
    scope = Article.includes(:user)

    ordered = case params[:sort]
    when "relevant"
      scope.order(popularity: :desc, created_at: :desc)
    else
      scope.order(created_at: :desc)
    end

    featured_article = ordered.first
    articles = ordered.offset(1)

    render inertia: "Articles/Index", props: {
      featuredArticle: featured_article ? serialize_article(featured_article) : nil,
      articles: articles.map { |a| serialize_article(a) }
    }
  end

  # GET /@:username/:slug(.:format)
  def show
    all_comments = @article.article_comments.includes(:user).order(popularity: :desc)
    comments_by_parent = all_comments.group_by(&:parent_id)
    comments_tree = build_comment_tree(comments_by_parent, nil)

    render inertia: "Articles/Show", props: {
      article: serialize_article(@article),
      comments: comments_tree
    }
  end

  # GET /new(.:format)
  def new
    @article = Article.new
    render inertia: "Articles/New", props: {
      article: {
        title: "",
        body: "",
        ref: ""
      }
    }
  end

  # GET /@:username/:slug/edit(.:format)
  def edit
    render inertia: "Articles/Edit", props: {
      article: serialize_article(@article)
    }
  end

  # POST /@:username/:slug(.:format)
  def create
    @article = current_user.articles.build(article_params)

    if @article.save
      redirect_to user_article_path(@article.user.username, @article.slug), notice: "Publicação criada com sucesso."
    else
      render inertia: "Articles/New", props: {
        article: {
          title: @article.title,
          body: @article.body,
          ref: @article.ref
        },
        errors: @article.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /@:username/:slug(.:format)
  def update
    if @article.update(article_params)
      redirect_to user_article_path(@article.user.username, @article.slug), notice: "Publicação atualizada com sucesso."
    else
      render inertia: "Articles/Edit", props: {
        article: serialize_article(@article).merge(
          title: @article.title,
          body: @article.body,
          ref: @article.ref
        ),
        errors: @article.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # PATCH /@:username/:slug/vote(.:format)
  def vote
    if current_user == @article.user
      redirect_to user_article_path(@article.user.username, @article.slug),
        alert: "Você não pode votar na própria publicação."
      return
    end
    direction = params[:up] ? :up : :down
    success = @article.vote(direction, current_user)

    if success
      redirect_to user_article_path(@article.user.username, @article.slug),
        notice: "Voto registrado com sucesso."
      return
    end

    # Determine why vote failed to provide a better message
    existing = @article.article_votes.find_by(user: current_user)
    if existing.nil?
      redirect_to user_article_path(@article.user.username, @article.slug),
        alert: "Erro ao registrar voto."
    elsif existing.vote == (direction == :up)
      redirect_to user_article_path(@article.user.username, @article.slug),
        alert: "Você já registrou esse voto."
    else
      redirect_to user_article_path(@article.user.username, @article.slug),
        alert: "Erro ao atualizar voto. Tente novamente."
    end
  end

  # DELETE /@:username/:slug/cancel(.:format)
  def destroy
    @article.destroy!
    redirect_to root_path, notice: "Publicação excluída com sucesso."
  end

  # POST /@:username/:slug/comments(.:format)
  def create_comment
    @article_comment = @article.article_comments.build(article_comment_params)
    @article_comment.user = current_user

    if @article_comment.save
      redirect_to user_article_path(@article.user.username, @article.slug)
    else
      all_comments = @article.article_comments.includes(:user).order(popularity: :desc)
      comments_by_parent = all_comments.group_by(&:parent_id)
      comments_tree = build_comment_tree(comments_by_parent, nil)

      render inertia: "Articles/Show", props: {
        article: serialize_article(@article),
        comments: comments_tree,
        commentErrors: @article_comment.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # PATCH /@:username/:slug/comments/:id/vote(.:format)
  def vote_comment
    @article_comment = @article.article_comments.find(params[:id])

    if current_user == @article_comment.user
      redirect_to user_article_path(@article.user.username, @article.slug),
        alert: "Você não pode votar no seu próprio comentário."
      return
    end

    success = @article_comment.vote(params[:up] ? :up : :down, current_user)

    if success
      redirect_to user_article_path(@article.user.username, @article.slug),
        notice: "Voto registrado com sucesso."
    else
      redirect_to user_article_path(@article.user.username, @article.slug),
        alert: "Você já registrou esse voto."
    end
  end

  # POST /@:username/:slug/comments/:id/comments(.:format)
  def create_comment_comment
    parent = @article.article_comments.find(params[:id])

    @article_comment = @article.article_comments.build(
      article_comment_params
    )

    @article_comment.user = current_user
    @article_comment.parent = parent
    @article_comment.depth = parent.depth + 1

    if @article_comment.save
      parent.increment!(:children_count)

      redirect_to user_article_path(@article.user.username, @article.slug)
    else
      all_comments = @article.article_comments.includes(:user).order(popularity: :desc)
      comments_by_parent = all_comments.group_by(&:parent_id)
      comments_tree = build_comment_tree(comments_by_parent, nil)

      render inertia: "Articles/Show", props: {
        article: serialize_article(@article),
        comments: comments_tree,
        commentErrors: @article_comment.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # PATCH /@:username/:slug/comments/:id/comments/:comment_id/vote(.:format)
  def vote_comment_comment
    @article_comment = @article.article_comments.find(params[:id])
    @article_comment.vote(params[:up] ? :up : :down, current_user)
  end

  # DELETE /@:username/:slug/comments/:id/cancel
  def destroy_comment
    @article_comment = @article.article_comments.find(params[:id])

    @article_comment.update!(
      deleted_at: Time.current
    )

    redirect_to user_article_path(@article.user.username, @article.slug),
      notice: "Comentário excluído com sucesso."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      if params[:username].present?
        user = User.find_by!(username: params[:username])
        slug = params[:slug] || params[:id]
        @article = user.articles.find_by!(slug: slug)
      else
        @article = Article.find(params[:id])
      end
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.expect(article: [ :title, :body, :published, :popularity, :ref ])
    end

    def article_comment_params
      params.expect(article_comment: [ :body ])
    end

    def article_comment_comment_params
      params.expect(article_comment_comment: [ :body ])
    end

    def serialize_article(article)
      {
        id: article.id,
        title: article.title,
        body: article.body,
        slug: article.slug,
        popularity: article.popularity,
        ref: article.ref,
        created_at: article.created_at,
        user: article.user.as_json(only: [:id, :username, :name])
      }
    end

    def build_comment_tree(comments_by_parent, parent_id = nil)
      (comments_by_parent[parent_id] || []).map do |comment|
        {
          id: comment.id,
          body: comment.body,
          popularity: comment.popularity,
          created_at: comment.created_at,
          deleted: comment.deleted?,
          user: comment.user.as_json(only: [:id, :username]),
          children: build_comment_tree(comments_by_parent, comment.id)
        }
      end
    end
end
