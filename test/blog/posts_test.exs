defmodule Blog.PostsTest do
  use Blog.DataCase

  alias Blog.Posts
  alias Blog.Posts.Post

  import Blog.PostsFixtures
  import Blog.AccountsFixtures

  describe "posts" do
    @invalid_attrs %{content: nil, title: nil}

    test "list_posts/0 returns all posts" do
      user = user_fixture()
      post = post_fixture(title: "First Post", user_id: user.id)
      assert Posts.list_posts() |> Repo.preload([:tags]) == [post]
    end

    test "list_posts/1 exact matching title title" do
      user = user_fixture()
      post = post_fixture(title: "First Post", user_id: user.id)
      assert Posts.list_posts(title: post.title) |> Repo.preload([:tags]) == [post]
    end

    test "list_posts/1 partial match beginning of title" do
      user = user_fixture()
      post = post_fixture(title: "First Post", user_id: user.id)
      assert Posts.list_posts(title: "First") |> Repo.preload([:tags]) == [post]
    end

    test "list_posts/1 partial match end of title" do
      user = user_fixture()
      post = post_fixture(title: "First Post", user_id: user.id)
      assert Posts.list_posts(title: "ost") |> Repo.preload([:tags]) == [post]
    end

    test "list_posts/1 partial match middle of title" do
      user = user_fixture()
      post = post_fixture(title: "First Post", user_id: user.id)
      assert Posts.list_posts(title: "st Po") |> Repo.preload([:tags]) == [post]
    end

    test "list_posts/1 partial match case insensitive" do
      user = user_fixture()
      post = post_fixture(title: "First Post", user_id: user.id)
      assert Posts.list_posts(title: "fIrSt") |> Repo.preload([:tags]) == [post]
    end

    test "list_posts/1 no match" do
      assert Posts.list_posts(title: "any search string") == []
    end

    test "list_posts/1 empty string" do
      user = user_fixture()
      post1 = post_fixture(title: "First Post", user_id: user.id)
      post2 = post_fixture(title: "Second Post", user_id: user.id)
      post3 = post_fixture(title: "Third Post", user_id: user.id)
      assert Posts.list_posts(title: "") |> Repo.preload([:tags]) == [post1, post2, post3]
    end

    test "get_post!/1 returns the post with given id" do
      user = user_fixture()
      post = post_fixture(user_id: user.id) |> Repo.preload(:comments)
      assert Posts.get_post!(post.id) |> Repo.preload([:tags]) == post
    end

    test "create_post/1 with valid data creates a post" do
      user = user_fixture()

      valid_attrs = %{
        user_id: user.id,
        content: "some content",
        title: "some title",
        published_on: ~D[2024-02-20]
      }

      assert {:ok, %Post{} = post} = Posts.create_post(valid_attrs)
      assert post.content == "some content"
      assert post.title == "some title"
      assert post.published_on == ~D[2024-02-20]
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)

      update_attrs = %{
        content: "some updated content",
        title: "some updated title",
        published_on: ~D[2024-02-20]
      }

      assert {:ok, %Post{} = post} = Posts.update_post(post, update_attrs)
      assert post.content == "some updated content"
      assert post.title == "some updated title"
      assert post.published_on == ~D[2024-02-20]
    end

    test "update_post/2 with invalid data returns error changeset" do
      user = user_fixture()
      post = post_fixture(user_id: user.id) |> Repo.preload(:comments)
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, @invalid_attrs)
      assert Posts.get_post!(post.id) |> Repo.preload([:tags]) == post
    end

    test "delete_post/1 deletes the post" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      assert %Ecto.Changeset{} = Posts.change_post(post)
    end
  end
end
