require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @article = articles(:one)
    @user = users(:one)
    # Log in the user by default
    post login_url, params: { login: @user.email, password: "password" }
  end

  test "should get index" do
    get root_url
    assert_response :success
  end

  test "should get new" do
    get new_article_url
    assert_response :success
  end

  test "should create article" do
    assert_difference("Article.count") do
      post articles_url, params: { article: { body: @article.body, popularity: @article.popularity, published: @article.published, ref: @article.ref, title: "Artigo Novo", user_id: @user.id } }
    end

    assert_redirected_to user_article_url(@user.username, Article.last.slug)
  end

  test "should show article" do
    get user_article_url(@article.user.username, @article.slug)
    assert_response :success
  end

  test "should get edit" do
    get user_edit_article_url(@article.user.username, @article.slug)
    assert_response :success
  end

  test "should update article" do
    patch article_url(@article), params: { article: { body: @article.body, popularity: @article.popularity, published: @article.published, ref: @article.ref, title: @article.title, user_id: @article.user_id } }
    assert_redirected_to user_article_url(@article.user.username, @article.slug)
  end

  test "should destroy article" do
    assert_difference("Article.count", -1) do
      delete article_url(@article)
    end

    assert_redirected_to root_url
  end

  test "should upvote a comment" do
    post login_url, params: { login: users(:two).email, password: "password" }
    comment = article_comments(:one)
    initial_popularity = comment.popularity

    patch user_article_vote_comment_url(username: @article.user.username, slug: @article.slug, id: comment.id), params: { up: true }

    assert_redirected_to user_article_url(@article.user.username, @article.slug)
    assert_equal initial_popularity + 1, comment.reload.popularity
  end

  test "should downvote a comment" do
    post login_url, params: { login: users(:two).email, password: "password" }
    comment = article_comments(:one)
    initial_popularity = comment.popularity

    patch user_article_vote_comment_url(username: @article.user.username, slug: @article.slug, id: comment.id), params: { up: false }

    assert_redirected_to user_article_url(@article.user.username, @article.slug)
    assert_equal initial_popularity - 1, comment.reload.popularity
  end

  test "should upvote an article" do
    post login_url, params: { login: users(:two).email, password: "password" }
    initial_popularity = @article.popularity

    patch user_article_vote_url(username: @article.user.username, slug: @article.slug), params: { up: true }

    assert_redirected_to user_article_url(@article.user.username, @article.slug)
    assert_equal initial_popularity + 1, @article.reload.popularity
  end

  test "should downvote an article" do
    post login_url, params: { login: users(:two).email, password: "password" }
    initial_popularity = @article.popularity

    patch user_article_vote_url(username: @article.user.username, slug: @article.slug), params: { up: false }

    assert_redirected_to user_article_url(@article.user.username, @article.slug)
    assert_equal initial_popularity - 1, @article.reload.popularity
  end

  test "should cancel article upvote on second click" do
    post login_url, params: { login: users(:two).email, password: "password" }
    initial_popularity = @article.popularity

    # First click: upvote
    patch user_article_vote_url(username: @article.user.username, slug: @article.slug), params: { up: true }
    assert_equal initial_popularity + 1, @article.reload.popularity

    # Second click: upvote again (should cancel)
    patch user_article_vote_url(username: @article.user.username, slug: @article.slug), params: { up: true }
    assert_equal initial_popularity, @article.reload.popularity
  end

  test "should cancel article downvote on second click" do
    post login_url, params: { login: users(:two).email, password: "password" }
    initial_popularity = @article.popularity

    # First click: downvote
    patch user_article_vote_url(username: @article.user.username, slug: @article.slug), params: { up: false }
    assert_equal initial_popularity - 1, @article.reload.popularity

    # Second click: downvote again (should cancel)
    patch user_article_vote_url(username: @article.user.username, slug: @article.slug), params: { up: false }
    assert_equal initial_popularity, @article.reload.popularity
  end

  test "should cancel comment upvote on second click" do
    post login_url, params: { login: users(:two).email, password: "password" }
    comment = article_comments(:one)
    initial_popularity = comment.popularity

    # First click: upvote
    patch user_article_vote_comment_url(username: @article.user.username, slug: @article.slug, id: comment.id), params: { up: true }
    assert_equal initial_popularity + 1, comment.reload.popularity

    # Second click: upvote again (should cancel)
    patch user_article_vote_comment_url(username: @article.user.username, slug: @article.slug, id: comment.id), params: { up: true }
    assert_equal initial_popularity, comment.reload.popularity
  end

  test "should cancel comment downvote on second click" do
    post login_url, params: { login: users(:two).email, password: "password" }
    comment = article_comments(:one)
    initial_popularity = comment.popularity

    # First click: downvote
    patch user_article_vote_comment_url(username: @article.user.username, slug: @article.slug, id: comment.id), params: { up: false }
    assert_equal initial_popularity - 1, comment.reload.popularity

    # Second click: downvote again (should cancel)
    patch user_article_vote_comment_url(username: @article.user.username, slug: @article.slug, id: comment.id), params: { up: false }
    assert_equal initial_popularity, comment.reload.popularity
  end
end
