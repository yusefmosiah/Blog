defmodule Blog.PostsTest do
  use Blog.DataCase

  alias Blog.Posts

  describe "posts" do
    alias Blog.Posts.Post

    import Blog.PostsFixtures

    @invalid_attrs %{content: nil, title: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Posts.list_posts() == [post]
    end

    test "list_posts/1 exact matching title title" do
      post = post_fixture(title: "First Post")
      assert Posts.list_posts(title: post.title) == [post]
    end

    test "list_posts/1 partial match beginning of title" do
      post = post_fixture(title: "First Post")
      assert Posts.list_posts(title: "First") == [post]
    end

    test "list_posts/1 partial match end of title" do
      post = post_fixture(title: "First Post")
      assert Posts.list_posts(title: "ost") == [post]
    end

    test "list_posts/1 partial match middle of title" do
      post = post_fixture(title: "First Post")
      assert Posts.list_posts(title: "st Po") == [post]
    end

    test "list_posts/1 partial match case insensitive" do
      post = post_fixture(title: "First Post")
      assert Posts.list_posts(title: "fIrSt") == [post]
    end

    test "list_posts/1 no match" do
      _post = post_fixture(title: "First Post")
      assert Posts.list_posts(title: "Second") == []
    end

    test "list_posts/1 empty string" do
      post1 = post_fixture(title: "First Post")
      post2 = post_fixture(title: "Second Post")
      post3 = post_fixture(title: "Third Post")
      assert Posts.list_posts(title: "") == [post1, post2, post3]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture() |> Repo.preload(:comments)
      assert Posts.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{content: "some content", title: "some title", published_on: ~D[2024-02-20]}

      assert {:ok, %Post{} = post} = Posts.create_post(valid_attrs)
      assert post.content == "some content"
      assert post.title == "some title"
      assert post.published_on == ~D[2024-02-20]
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()

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
      post = post_fixture() |> Repo.preload(:comments)
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, @invalid_attrs)
      assert post == Posts.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Posts.change_post(post)
    end
  end
end
