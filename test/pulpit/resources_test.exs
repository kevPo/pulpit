defmodule Pulpit.ResourcesTest do
  use Pulpit.DataCase

  alias Pulpit.Resources

  describe "sermons" do
    alias Pulpit.Resources.Sermon

    import Pulpit.ResourcesFixtures

    @invalid_attrs %{references: nil, title: nil, written_at: nil}

    test "list_sermons/0 returns all sermons" do
      sermon = sermon_fixture()
      assert Resources.list_sermons() == [sermon]
    end

    test "get_sermon!/1 returns the sermon with given id" do
      sermon = sermon_fixture()
      assert Resources.get_sermon!(sermon.id) == sermon
    end

    test "create_sermon/1 with valid data creates a sermon" do
      valid_attrs = %{references: "some references", title: "some title", written_at: ~N[2022-11-17 04:17:00]}

      assert {:ok, %Sermon{} = sermon} = Resources.create_sermon(valid_attrs)
      assert sermon.references == "some references"
      assert sermon.title == "some title"
      assert sermon.written_at == ~N[2022-11-17 04:17:00]
    end

    test "create_sermon/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Resources.create_sermon(@invalid_attrs)
    end

    test "update_sermon/2 with valid data updates the sermon" do
      sermon = sermon_fixture()
      update_attrs = %{references: "some updated references", title: "some updated title", written_at: ~N[2022-11-18 04:17:00]}

      assert {:ok, %Sermon{} = sermon} = Resources.update_sermon(sermon, update_attrs)
      assert sermon.references == "some updated references"
      assert sermon.title == "some updated title"
      assert sermon.written_at == ~N[2022-11-18 04:17:00]
    end

    test "update_sermon/2 with invalid data returns error changeset" do
      sermon = sermon_fixture()
      assert {:error, %Ecto.Changeset{}} = Resources.update_sermon(sermon, @invalid_attrs)
      assert sermon == Resources.get_sermon!(sermon.id)
    end

    test "delete_sermon/1 deletes the sermon" do
      sermon = sermon_fixture()
      assert {:ok, %Sermon{}} = Resources.delete_sermon(sermon)
      assert_raise Ecto.NoResultsError, fn -> Resources.get_sermon!(sermon.id) end
    end

    test "change_sermon/1 returns a sermon changeset" do
      sermon = sermon_fixture()
      assert %Ecto.Changeset{} = Resources.change_sermon(sermon)
    end
  end
end
