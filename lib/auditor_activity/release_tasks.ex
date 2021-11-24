defmodule AuditorActivity.ReleaseTasks do
    @start_apps [
      :postgrex,
      :ecto,
      :ecto_sql
    ]
  
    @myapps [
      :auditor_activity
    ]
  
    @repos [
      AuditorActivity.Repo
    ]
  
    # Run all the migrations of the Applications
    def run_migrations do
      IO.puts("Loading...")
      # Load the code for myapp, but don't start it
      :ok = Application.load(:auditor_activity)
  
      IO.puts("Starting dependencies..")
      # Start apps necessary for executing migrations
      Enum.each(@start_apps, &Application.ensure_all_started/1)
  
      # Start the Repo(s) for myapp
      IO.puts("Starting repos..")
      Enum.each(@repos, & &1.start_link(pool_size: 2))
  
      # Run migrations
      Enum.each(@myapps, &run_migrations_for/1)
      # Signal shutdown
      IO.puts("Success!")
      :init.stop()
    end
  
    def run_migrations_with_seed do
      IO.puts("Loading ...")
      # Load the code for myapp, but don't start it
      :ok = Application.load(:auditor_activity)
  
      IO.puts("Starting dependencies..")
      # Start apps necessary for executing migrations
      Enum.each(@start_apps, &Application.ensure_all_started/1)
  
      # Start the Repo(s) for myapp
      IO.puts("Starting repos..")
      Enum.each(@repos, & &1.start_link(pool_size: 2))
  
      # Run migrations
      Enum.each(@myapps, &run_migrations_for/1)
  
      # Run the seed script if it exists
      seed_script = Path.join([priv_dir(:auditor_activity), "repo"])
  
      if File.exists?(seed_script) do
        IO.puts("Running seed script..")
        Code.eval_file("seeds.exs", seed_script)
       # Code.eval_file("kvartel_west_seeds.exs", seed_script)
      end
  
      # Signal shutdown
      IO.puts("Success!")
      :init.stop()
    end
  
    def update_asset_table do
      IO.puts("Loading ...")
      # Load the code for myapp, but don't start it
      :ok = Application.load(:auditor_activity)
  
      IO.puts("Starting dependencies..")
      # Start apps necessary for executing migrations
      Enum.each(@start_apps, &Application.ensure_all_started/1)
  
      # Start the Repo(s) for myapp
      IO.puts("Starting repos..")
      Enum.each(@repos, & &1.start_link(pool_size: 2))
  
      # Run the seed script if it exists
      seed_script = Path.join([priv_dir(:auditor_activity), "repo"])
  
      if File.exists?(seed_script) do
        IO.puts("Running seed script..")
        Code.eval_file("update_asset_table.exs", seed_script)
      end
  
      # Signal shutdown
      IO.puts("Success!")
      :init.stop()
    end
  
    def run_seeds do
      IO.puts("Loading ...")
      # Load the code for myapp, but don't start it
      :ok = Application.load(:auditor_activity)
  
      IO.puts("Starting dependencies..")
      # Start apps necessary for executing migrations
      Enum.each(@start_apps, &Application.ensure_all_started/1)
  
      # Start the Repo(s) for myapp
      IO.puts("Starting repos..")
      Enum.each(@repos, & &1.start_link(pool_size: 2))
  
      # Run the seed script if it exists
      seed_script = Path.join([priv_dir(:auditor_activity), "repo"])
  
      if File.exists?(seed_script) do
        IO.puts("Running seed script..")
        Code.eval_file("seeds.exs", seed_script)
       # Code.eval_file("kvartel_west_seeds.exs", seed_script)
      end
  
      # Signal shutdown
      IO.puts("Success!")
      :init.stop()
    end
  
    def priv_dir(app), do: "#{:code.priv_dir(app)}"
  
    defp run_migrations_for(app) do
      IO.puts("Running migrations for #{app}")
      Ecto.Migrator.run(AuditorActivity.Repo, migrations_path(app), :up, all: true)
    end
  
    defp migrations_path(app), do: Path.join([priv_dir(app), "repo", "migrations"])
   # defp seed_path(app), do: Path.join([priv_dir(app), "repo", "seeds.exs"])
  end