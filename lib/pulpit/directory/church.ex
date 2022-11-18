defmodule Pulpit.Directory.Church do
  use Ecto.Schema
  import Ecto.Changeset

  schema "churches" do
    field :name, :string
    belongs_to :user, Pulpit.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(church, attrs) do
    church
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
