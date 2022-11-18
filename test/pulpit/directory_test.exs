defmodule Pulpit.DirectoryTest do
  use Pulpit.DataCase

  alias Pulpit.Directory

  describe "churches" do
    alias Pulpit.Directory.Church

    import Pulpit.DirectoryFixtures

    @invalid_attrs %{name: nil}

    test "list_churches/0 returns all churches" do
      church = church_fixture()
      assert Directory.list_churches() == [church]
    end

    test "get_church!/1 returns the church with given id" do
      church = church_fixture()
      assert Directory.get_church!(church.id) == church
    end

    test "create_church/1 with valid data creates a church" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Church{} = church} = Directory.create_church(valid_attrs)
      assert church.name == "some name"
    end

    test "create_church/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Directory.create_church(@invalid_attrs)
    end

    test "update_church/2 with valid data updates the church" do
      church = church_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Church{} = church} = Directory.update_church(church, update_attrs)
      assert church.name == "some updated name"
    end

    test "update_church/2 with invalid data returns error changeset" do
      church = church_fixture()
      assert {:error, %Ecto.Changeset{}} = Directory.update_church(church, @invalid_attrs)
      assert church == Directory.get_church!(church.id)
    end

    test "delete_church/1 deletes the church" do
      church = church_fixture()
      assert {:ok, %Church{}} = Directory.delete_church(church)
      assert_raise Ecto.NoResultsError, fn -> Directory.get_church!(church.id) end
    end

    test "change_church/1 returns a church changeset" do
      church = church_fixture()
      assert %Ecto.Changeset{} = Directory.change_church(church)
    end
  end
end
