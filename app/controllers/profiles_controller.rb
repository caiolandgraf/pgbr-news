class ProfilesController < ApplicationController
  before_action :set_user
  before_action :require_owner, only: %i[ edit update ]

  def show
    render inertia: "Profiles/Show", props: {
      profileUser: @user.as_json(only: [ :id, :name, :username, :bio, :created_at ]),
      articles: @user.articles.includes(:article_votes).order(created_at: :desc).map { |a| serialize_article(a) }
    }
  end

  def edit
    render inertia: "Profiles/Edit", props: {
      profileUser: @user.as_json(only: [ :id, :name, :username, :bio, :email ])
    }
  end

  def update
    if @user.update(profile_params)
      redirect_to profile_path(@user), notice: "Perfil atualizado com sucesso."
    else
      render inertia: "Profiles/Edit", props: {
        profileUser: @user.as_json(only: [ :id, :name, :username, :bio, :email ]),
        errors: @user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find_by!(username: params[:username].to_s.downcase)
  end

  def require_owner
    return if logged_in? && current_user == @user

    redirect_to profile_path(@user), alert: "Você só pode editar o seu próprio perfil."
  end

  def profile_params
    params.expect(user: [ :name, :username, :bio ])
  end

  def serialize_article(article)
    upvotes = article.article_votes.loaded? ? article.article_votes.select(&:vote).size : article.article_votes.where(vote: true).count
    downvotes = article.article_votes.loaded? ? article.article_votes.reject(&:vote).size : article.article_votes.where(vote: false).count
    {
      id: article.id,
      title: article.title,
      body: article.body,
      slug: article.slug,
      popularity: article.popularity,
      upvotes: upvotes,
      downvotes: downvotes,
      ref: article.ref,
      created_at: article.created_at,
      user: article.user.as_json(only: [ :id, :username, :name ])
    }
  end
end
