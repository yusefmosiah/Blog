defmodule BlogWeb.PostController do
  use BlogWeb, :controller

  alias Blog.Posts
  alias Blog.Posts.Post
  alias Blog.Comments
  alias Blog.Comments.Comment
  alias Blog.Tags.Tag
  alias Blog.Tags

  plug :require_user_owns_post when action in [:edit, :update, :delete]

  def index(conn, %{"title" => title}) do
    posts = Posts.list_posts(title: title)
    render(conn, "index.html", posts: posts)
  end

  def index(conn, _params) do
    posts = Posts.list_posts()
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    tags_with_id = Tags.list_tags() |> Enum.map(fn tag -> {tag.name, tag.id} end)

    changeset = Posts.change_post(%Post{})
    render(conn, "new.html", changeset: changeset, tags_with_id: tags_with_id)
  end

  def create(conn, %{"post" => post_params}) do
    IO.inspect(post_params, label: "POST PARAMS: post_params")
    tags_with_id = Tags.list_tags() |> Enum.map(fn tag -> {tag.name, tag.id} end)

    case Posts.create_post(post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, tags_with_id: tags_with_id)
    end
  end

  def show(conn, %{"id" => id}) do
    post =
      Posts.get_post!(id)
      |> Blog.Repo.preload([:comments, :tags])
      |> IO.inspect(label: "TAGGED?: post")

    comment_changeset = Comments.change_comment(%Comment{})
    render(conn, "show.html", post: post, comment_changeset: comment_changeset)
  end

  def edit(conn, %{"id" => id}) do
    tags_with_id = Tags.list_tags() |> Enum.map(fn tag -> {tag.name, tag.id} end)

    post =
      Posts.get_post!(id)
      |> Blog.Repo.preload([:tags])
      |> IO.inspect(label: "PRELOADED IN EDIT: post")

    changeset = Posts.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset, tags_with_id: tags_with_id)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    tags_with_id = Tags.list_tags() |> Enum.map(fn tag -> {tag.name, tag.id} end)
    post = Posts.get_post!(id) |> Blog.Repo.preload([:tags])

    case Posts.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset, tags_with_id: tags_with_id)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    {:ok, _post} = Posts.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :index))
  end

  def require_user_owns_post(conn, opts) do
    IO.inspect(opts, label: "OPTS")
    IO.inspect(conn, label: "IN REQUIRE_USER_OWNS_POST: conn")
    post_id = conn.path_params["id"] |> String.to_integer()
    post = Posts.get_post!(post_id)

    if post.user_id ==
         get_in(conn.assigns, [Access.key!(:current_user), Access.key!(:id)]) do
      conn
    else
      conn
      |> put_flash(:error, "You do not own this resource.")
      |> redirect(to: Routes.post_path(conn, :index))
      |> halt()
    end
  end
end
