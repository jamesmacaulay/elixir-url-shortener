defmodule PhoenixUrlShortener.Repo.Migrations.CreateShortcut do
  use Ecto.Migration

  def change do
    create table(:shortcuts) do
      add :slug, :string, null: false
      add :target_url, :string, null: false

      timestamps
    end

    create index(:shortcuts, [:slug], unique: true)
  end
end
