ExUnit.start()
ExUnit.configure(exclude: [external: true])
Ecto.Adapters.SQL.Sandbox.mode(Blog.Repo, :manual)
