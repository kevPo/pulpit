defmodule Pulpit.ResourcesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pulpit.Resources` context.
  """

  @doc """
  Generate a unique sermon title.
  """
  def unique_sermon_title, do: "some title#{System.unique_integer([:positive])}"

  @doc """
  Generate a sermon.
  """
  def sermon_fixture(attrs \\ %{}) do
    {:ok, sermon} =
      attrs
      |> Enum.into(%{
        references: "some references",
        title: unique_sermon_title(),
        written_at: ~N[2022-11-17 04:17:00]
      })
      |> Pulpit.Resources.create_sermon()

    sermon
  end
end
