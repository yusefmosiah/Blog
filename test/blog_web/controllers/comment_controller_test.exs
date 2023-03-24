defmodule BlogWeb.CommentControllerTest do
  use BlogWeb.ConnCase

  import Blog.CommentsFixtures
  import Blog.PostsFixtures

  @create_attrs %{content: "some content"}
  @update_attrs %{content: "some updated content"}
  @invalid_attrs %{content: nil}

  describe "index" do
    test "lists all comments", %{conn: conn} do
      conn = get(conn, Routes.comment_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Comments"
    end
  end

  describe "new comment" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.comment_path(conn, :new))
      assert html_response(conn, 200) =~ "New Comment"
    end
  end

  describe "create comment" do
    test "create comment for associated post", %{conn: conn} do
      post = post_fixture()
      comment = comment_fixture(post_id: post.id) |> Blog.Repo.preload(:post)
      IO.inspect(comment, label: "XXXXXXXcomment")

      conn = post(conn, Routes.comment_path(conn, :create), comment: %{comment: comment})
      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.comment_path(conn, :show, id)

      conn = get(conn, Routes.comment_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Comment"
    end

    test "redirects to show when data is valid", %{conn: conn} do
      post = post_fixture()
      comment = comment_fixture(post_id: post.id)

      conn = post(conn, Routes.comment_path(conn, :create), comment: %{comment: comment})

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.comment_path(conn, :show, id)

      conn = get(conn, Routes.comment_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Comment"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      post = post_fixture()
      {:error, comment} = comment_fixture(%{post_id: post.id, content: nil})

      conn = post(conn, Routes.comment_path(conn, :create), comment: %{comment: comment})
      assert html_response(conn, 200) =~ "New Comment"
    end
  end

  describe "edit comment" do
    setup [:create_comment]

    test "renders form for editing chosen comment", %{conn: conn, comment: comment} do
      conn = get(conn, Routes.comment_path(conn, :edit, comment))
      assert html_response(conn, 200) =~ "Edit Comment"
    end
  end

  describe "update comment" do
    setup [:create_comment]

    test "redirects when data is valid", %{conn: conn, comment: comment} do
      post = post_fixture()
      comment = comment_fixture(post_id: post.id)

      conn = put(conn, Routes.comment_path(conn, :update, comment), comment: %{comment: comment})
      assert redirected_to(conn) == Routes.comment_path(conn, :show, comment)

      conn = get(conn, Routes.comment_path(conn, :show, comment))
      assert html_response(conn, 200) =~ "Show Comment"
    end

    test "renders errors when data is invalid", %{conn: conn, comment: comment} do
      conn = put(conn, Routes.comment_path(conn, :update, comment), comment: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Comment"
    end
  end

  describe "delete comment" do
    setup [:create_comment]

    test "deletes chosen comment", %{conn: conn, comment: comment} do
      conn = delete(conn, Routes.comment_path(conn, :delete, comment))
      assert redirected_to(conn) == Routes.comment_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.comment_path(conn, :show, comment))
      end
    end
  end

  def create_comment(_) do
    post = post_fixture()
    comment = comment_fixture(post_id: post.id)
    %{comment: comment}
  end
end
