defmodule Pulpit.Directory do
  @moduledoc """
  The Directory context.
  """

  import Ecto.Query, warn: false
  alias Pulpit.Repo

  alias Pulpit.Directory.Church
  alias Pulpit.Accounts

  @doc """
  Returns the list of churches.

  ## Examples

      iex> list_churches()
      [%Church{}, ...]

  """
  def list_churches do
    Repo.all(Church)
  end

  @doc """
  Gets a single church.

  Raises `Ecto.NoResultsError` if the Church does not exist.

  ## Examples

      iex> get_church!(123)
      %Church{}

      iex> get_church!(456)
      ** (Ecto.NoResultsError)

  """
  def get_church!(id), do: Repo.get!(Church, id)

  @doc """
  Creates a church.

  ## Examples

      iex> create_church(%User{}, %{field: value})
      {:ok, %Church{}}

      iex> create_church(%User{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_church(%Accounts.User{} = user, attrs \\ %{}) do
    %Church{}
    |> Church.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Updates a church.

  ## Examples

      iex> update_church(church, %{field: new_value})
      {:ok, %Church{}}

      iex> update_church(church, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_church(%Church{} = church, attrs) do
    church
    |> Church.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a church.

  ## Examples

      iex> delete_church(church)
      {:ok, %Church{}}

      iex> delete_church(church)
      {:error, %Ecto.Changeset{}}

  """
  def delete_church(%Church{} = church) do
    Repo.delete(church)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking church changes.

  ## Examples

      iex> change_church(church)
      %Ecto.Changeset{data: %Church{}}

  """
  def change_church(%Church{} = church, attrs \\ %{}) do
    Church.changeset(church, attrs)
  end

  def list_user_churches(%Accounts.User{} = user) do
    Church
    |> user_churches_query(user)
    |> Repo.all()
  end

  def get_user_church!(%Accounts.User{} = user, id) do
    Church
    |> user_churches_query(user)
    |> Repo.get!(id)
  end

  defp user_churches_query(query, %Accounts.User{id: user_id}) do
    from(v in query, where: v.user_id == ^user_id)
  end
end
