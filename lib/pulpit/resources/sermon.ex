defmodule Pulpit.Resources.Sermon do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sermons" do
    field :references, :string
    field :title, :string
    field :written_at, :naive_datetime

    belongs_to :user, Pulpit.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(sermon, attrs) do
    sermon
    |> cast(attrs, [:title, :references, :written_at])
    |> validate_required([:title])
    |> unique_constraint(:title)
  end
end
