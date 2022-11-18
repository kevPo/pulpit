defmodule Pulpit.Resources do
  @moduledoc """
  The Resources context.
  """

  import Ecto.Query, warn: false
  alias Pulpit.Repo

  alias Pulpit.Accounts
  alias Pulpit.Resources.Sermon

  @doc """
  Returns the list of sermons.

  ## Examples

      iex> list_sermons()
      [%Sermon{}, ...]

  """
  def list_sermons do
    Repo.all(Sermon)
  end

  @doc """
  Gets a single sermon.

  Raises `Ecto.NoResultsError` if the Sermon does not exist.

  ## Examples

      iex> get_sermon!(123)
      %Sermon{}

      iex> get_sermon!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sermon!(id), do: Repo.get!(Sermon, id)

  @doc """
  Creates a sermon.

  ## Examples

      iex> create_sermon(%{field: value})
      {:ok, %Sermon{}}

      iex> create_sermon(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sermon(%Accounts.User{} = user, attrs \\ %{}) do
    %Sermon{}
    |> Sermon.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Updates a sermon.

  ## Examples

      iex> update_sermon(sermon, %{field: new_value})
      {:ok, %Sermon{}}

      iex> update_sermon(sermon, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sermon(%Sermon{} = sermon, attrs) do
    sermon
    |> Sermon.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a sermon.

  ## Examples

      iex> delete_sermon(sermon)
      {:ok, %Sermon{}}

      iex> delete_sermon(sermon)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sermon(%Sermon{} = sermon) do
    Repo.delete(sermon)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sermon changes.

  ## Examples

      iex> change_sermon(sermon)
      %Ecto.Changeset{data: %Sermon{}}

  """
  def change_sermon(%Sermon{} = sermon, attrs \\ %{}) do
    Sermon.changeset(sermon, attrs)
  end

  def list_user_sermons(%Accounts.User{} = user) do
    Sermon
    |> user_sermons_query(user)
    |> Repo.all()
  end

  def get_user_sermon!(%Accounts.User{} = user, id) do
    Sermon
    |> user_sermons_query(user)
    |> Repo.get!(id)
  end

  defp user_sermons_query(query, %Accounts.User{id: user_id}) do
    from(v in query, where: v.user_id == ^user_id)
  end
end
