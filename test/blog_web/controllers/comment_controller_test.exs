defmodule BlogWeb.CommentControllerTest do
  use BlogWeb.ConnCase

  import Blog.CommentsFixtures
  import Blog.PostsFixtures
  import Blog.AccountsFixtures

  describe "index" do
    test "lists all comments", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      conn = get(conn, Routes.comment_path(conn, :index))
      assert html_response(conn, 200) =~ "Comments"
    end
  end

  ###     COMMENTED OUT BECAUSE OF ISSUE WITH ENV VAR NOT LOADED IN CI
  # describe "create comment" do
  #   test "create comment for associated post", %{conn: conn} do
  #     user = user_fixture()
  #     conn = log_in_user(conn, user)
  #     post = post_fixture(%{user_id: user.id})

  #     conn =
  #       post(conn, Routes.comment_path(conn, :create, post.id),
  #         comment: %{post_id: post.id, content: "some content"}
  #       )

  #     assert %{id: id} = redirected_params(conn)
  #     assert redirected_to(conn) == Routes.post_path(conn, :show, id)

  #     conn = get(conn, Routes.post_path(conn, :show, id))
  #     assert html_response(conn, 200) =~ "Comment created successfully"
  #   end
  #
  # test "redirects to show when data is valid", %{conn: conn} do
  #   user = user_fixture()
  #   conn = log_in_user(conn, user)
  #   post = post_fixture(%{user_id: user.id})

  #   conn =
  #     post(conn, Routes.comment_path(conn, :create, post.id),
  #       comment: %{post_id: post.id, content: "some content"}
  #     )

  #   assert %{id: id} = redirected_params(conn)
  #   assert redirected_to(conn) == Routes.post_path(conn, :show, id)

  #   conn = get(conn, Routes.post_path(conn, :show, id))
  #   assert html_response(conn, 200) =~ "Comment created successfully"
  # end

  test "renders errors when data is invalid", %{conn: conn} do
    user = user_fixture()
    conn = log_in_user(conn, user)
    post = post_fixture(%{user_id: user.id})

    conn =
      post(conn, Routes.comment_path(conn, :create, post.id),
        comment: %{post_id: post.id, content: nil}
      )

    assert html_response(conn, 200) =~ "some title"
  end

  # end

  describe "edit comment" do
    test "renders form for editing chosen comment", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      post = post_fixture(%{user_id: user.id})
      comment = comment_fixture(%{post_id: post.id})
      conn = get(conn, Routes.comment_path(conn, :edit, comment))
      assert html_response(conn, 200) =~ "Edit Comment"
    end
  end

  describe "update comment" do
    test "redirects when data is valid", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      post = post_fixture(%{user_id: user.id})
      comment = comment_fixture(%{post_id: post.id})
      conn = put(conn, Routes.comment_path(conn, :update, comment), comment: %{comment: comment})
      assert redirected_to(conn) == Routes.comment_path(conn, :show, comment)

      conn = get(conn, Routes.comment_path(conn, :show, comment))
      assert html_response(conn, 200) =~ "Show Comment"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      post = post_fixture(%{user_id: user.id})
      comment = comment_fixture(%{post_id: post.id})
      conn = put(conn, Routes.comment_path(conn, :update, comment), comment: %{content: nil})

      assert html_response(conn, 200) =~
               "Oops, something went wrong! Please check the errors below."
    end
  end

  describe "delete comment" do
    test "deletes chosen comment", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      post = post_fixture(%{user_id: user.id})
      comment = comment_fixture(%{post_id: post.id})
      conn = delete(conn, Routes.comment_path(conn, :delete, comment))
      assert redirected_to(conn) == Routes.comment_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.comment_path(conn, :show, comment))
      end
    end
  end
end
