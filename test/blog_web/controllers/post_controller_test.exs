defmodule BlogWeb.PostControllerTest do
  use BlogWeb.ConnCase
  import Blog.AccountsFixtures
  import Blog.PostsFixtures

  @update_attrs %{
    content: "some updated content",
    title: "some updated title",
    published_on: ~D[2024-02-21]
  }
  @invalid_attrs %{content: nil, title: nil, published_on: nil}

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :index))
      assert html_response(conn, 200) =~ "Posts"
    end
  end

  describe "new post" do
    test "renders form", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      conn = get(conn, Routes.post_path(conn, :new))
      assert html_response(conn, 200) =~ "settings"
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "create post" do
    test "redirects to show when data is valid", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)

      create_attrs = %{
        content: "some content",
        title: "some title",
        user_id: user.id,
        published_on: ~D[2024-02-20]
      }

      conn = post(conn, Routes.post_path(conn, :create), post: create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.post_path(conn, :show, id)

      conn = get(conn, Routes.post_path(conn, :show, id))
      assert html_response(conn, 200) =~ "some title"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      conn = post(conn, Routes.post_path(conn, :create), post: @invalid_attrs)
      assert html_response(conn, 200) =~ "settings"
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "edit post" do
    test "renders form for editing chosen post", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      post = post_fixture(%{user_id: user.id})
      conn = get(conn, Routes.post_path(conn, :edit, post))
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "update post" do
    test "redirects when data is valid", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      post = post_fixture(%{user_id: user.id})
      conn = put(conn, Routes.post_path(conn, :update, post), post: @update_attrs)
      assert redirected_to(conn) == Routes.post_path(conn, :show, post)

      conn = get(conn, Routes.post_path(conn, :show, post))
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      post = post_fixture(%{user_id: user.id})
      conn = put(conn, Routes.post_path(conn, :update, post), post: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "delete post" do
    test "deletes chosen post", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      post = post_fixture(%{user_id: user.id})
      conn = delete(conn, Routes.post_path(conn, :delete, post))
      assert redirected_to(conn) == Routes.post_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.post_path(conn, :show, post))
      end
    end
  end
end
