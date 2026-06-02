require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @article = articles(:one)
    @user = users(:one)
    # Log in the user by default
    post login_url, params: { email: @user.email, password: "password" }
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
end
