defmodule Pulpit.Repo.Migrations.CreateChurches do
  use Ecto.Migration

  def change do
    create table(:churches) do
      add :name, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:churches, [:name])
    create index(:churches, [:user_id])
  end
end
