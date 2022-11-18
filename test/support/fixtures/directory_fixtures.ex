defmodule Pulpit.DirectoryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pulpit.Directory` context.
  """

  @doc """
  Generate a unique church name.
  """
  def unique_church_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a church.
  """
  def church_fixture(attrs \\ %{}) do
    {:ok, church} =
      attrs
      |> Enum.into(%{
        name: unique_church_name()
      })
      |> Pulpit.Directory.create_church()

    church
  end
end
