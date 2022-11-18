defmodule PulpitWeb.ChurchLiveTest do
  use PulpitWeb.ConnCase

  import Phoenix.LiveViewTest
  import Pulpit.DirectoryFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_church(_) do
    church = church_fixture()
    %{church: church}
  end

  describe "Index" do
    setup [:create_church]

    test "lists all churches", %{conn: conn, church: church} do
      {:ok, _index_live, html} = live(conn, ~p"/churches")

      assert html =~ "Listing Churches"
      assert html =~ church.name
    end

    test "saves new church", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/churches")

      assert index_live |> element("a", "New Church") |> render_click() =~
               "New Church"

      assert_patch(index_live, ~p"/churches/new")

      assert index_live
             |> form("#church-form", church: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#church-form", church: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/churches")

      assert html =~ "Church created successfully"
      assert html =~ "some name"
    end

    test "updates church in listing", %{conn: conn, church: church} do
      {:ok, index_live, _html} = live(conn, ~p"/churches")

      assert index_live |> element("#churches-#{church.id} a", "Edit") |> render_click() =~
               "Edit Church"

      assert_patch(index_live, ~p"/churches/#{church}/edit")

      assert index_live
             |> form("#church-form", church: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#church-form", church: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/churches")

      assert html =~ "Church updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes church in listing", %{conn: conn, church: church} do
      {:ok, index_live, _html} = live(conn, ~p"/churches")

      assert index_live |> element("#churches-#{church.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#church-#{church.id}")
    end
  end

  describe "Show" do
    setup [:create_church]

    test "displays church", %{conn: conn, church: church} do
      {:ok, _show_live, html} = live(conn, ~p"/churches/#{church}")

      assert html =~ "Show Church"
      assert html =~ church.name
    end

    test "updates church within modal", %{conn: conn, church: church} do
      {:ok, show_live, _html} = live(conn, ~p"/churches/#{church}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Church"

      assert_patch(show_live, ~p"/churches/#{church}/show/edit")

      assert show_live
             |> form("#church-form", church: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#church-form", church: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/churches/#{church}")

      assert html =~ "Church updated successfully"
      assert html =~ "some updated name"
    end
  end
end
