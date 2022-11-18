defmodule Pulpit.Repo.Migrations.CreateSermons do
  use Ecto.Migration

  def change do
    create table(:sermons) do
      add :title, :string, null: false
      add :references, :text
      add :written_at, :naive_datetime
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:sermons, [:title])
    create index(:sermons, [:user_id])
  end
end
