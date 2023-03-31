# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Blog.Repo.insert!(%Blog.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
# alias Blog.Posts.Post
# alias Blog.Posts
# alias Blog.Comments.Comment
# alias Blog.Repo


# {:ok, tag1} = Blog.Tags.create_tag(%{name: "elixir"})
# {:ok, tag2} = Blog.Tags.create_tag(%{name: "phoenix"})
# {:ok, tag3} = Blog.Tags.create_tag(%{name: "ecto"})
# {:ok, tag4} = Blog.Tags.create_tag(%{name: "tailwind"})


# {:ok, user} = Blog.Accounts.register_user(%{
#   email: "test@test.test",
#   password: "password1234567",
# })
# post_sans_comments = %Post{
#   user_id: user.id,
#   title: "My first post",
#   content: "Hello world!",
#   tags: [tag1.id, tag2.id],
#   published_on: Date.utc_today(),
#   visible: true
# }

# post_with_comments = %Post{
#   user_id: user.id,
#   title: "My second post",
#   content: "content of post 2",
#   tags: [tag3.id, tag4.id],
#   published_on: Date.utc_today(),
#   visible: true,
#   comments: [
#     %Comment{content: "First!"},
#     %Comment{content: "Second!"},
#     %Comment{content: "Third!"}
#   ]
# }

# Repo.insert!(post_sans_comments)
# Repo.insert!(post_with_comments)
# Posts.create_post(post_sans_comments)
# Posts.create_post(post_with_comments)


# emojis = Exmoji.all() |> Enum.map(&Exmoji.EmojiChar.render/1)

# random_comment = fn random ->
#   cond do
#     random > 70 -> Faker.Lorem.paragraphs() |> Enum.join("\n\n")
#     random > 50 -> Faker.Lorem.paragraph()
#     random > 30 -> Faker.Lorem.sentences() |> Enum.join(" ")
#     random > 10 -> Faker.Lorem.sentence()
#     true -> emojis |> Enum.shuffle() |> Enum.take(Enum.random(1..20)) |> Enum.join("")
#   end
# end

# posts_with_comments =
#   for i <- 0..99 do
#     content =
#       Faker.Lorem.paragraphs()
#       |> Enum.join("\n\n")

#     emojis =
#       emojis
#       |> Enum.shuffle()
#       |> Enum.take(Enum.random(1..10))
#       |> Enum.join("")

#     comments =
#       for _ <- 0..Enum.random(1..40) do
#         1..100 |> Enum.random() |> random_comment.()
#       end
#       |> Enum.map(&%Comment{content: &1})

#     %Post{
#       title: Faker.Lorem.Shakespeare.as_you_like_it(),
#       content: "#{i} " <> content,
#       published_on: Date.utc_today(),
#       visible: true,
#       comments: comments
#     }
#     |> Repo.insert!()
#   end

# comments =
#   for _ <- 0..Enum.random(1..40) do
#     1..100 |> Enum.random() |> random_comment.()
#   end
#   |> Enum.map(&%{content: &1})

# posts_sans_comments =
#   for i <- 100..200 do
#     content =
#       Faker.Lorem.paragraphs()
#       |> Enum.join("\n\n")

#     %Post{
#       title: Faker.Lorem.Shakespeare.as_you_like_it(),
#       content: "#{i} " <> content,
#       published_on: Date.utc_today(),
#       visible: true
#     }
#     |> Repo.insert!()
#   end
