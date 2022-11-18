defmodule PulpitWeb.SermonLiveTest do
  use PulpitWeb.ConnCase

  import Phoenix.LiveViewTest
  import Pulpit.ResourcesFixtures

  @create_attrs %{references: "some references", title: "some title", written_at: "2022-11-17T04:17:00"}
  @update_attrs %{references: "some updated references", title: "some updated title", written_at: "2022-11-18T04:17:00"}
  @invalid_attrs %{references: nil, title: nil, written_at: nil}

  defp create_sermon(_) do
    sermon = sermon_fixture()
    %{sermon: sermon}
  end

  describe "Index" do
    setup [:create_sermon]

    test "lists all sermons", %{conn: conn, sermon: sermon} do
      {:ok, _index_live, html} = live(conn, ~p"/sermons")

      assert html =~ "Listing Sermons"
      assert html =~ sermon.references
    end

    test "saves new sermon", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/sermons")

      assert index_live |> element("a", "New Sermon") |> render_click() =~
               "New Sermon"

      assert_patch(index_live, ~p"/sermons/new")

      assert index_live
             |> form("#sermon-form", sermon: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#sermon-form", sermon: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/sermons")

      assert html =~ "Sermon created successfully"
      assert html =~ "some references"
    end

    test "updates sermon in listing", %{conn: conn, sermon: sermon} do
      {:ok, index_live, _html} = live(conn, ~p"/sermons")

      assert index_live |> element("#sermons-#{sermon.id} a", "Edit") |> render_click() =~
               "Edit Sermon"

      assert_patch(index_live, ~p"/sermons/#{sermon}/edit")

      assert index_live
             |> form("#sermon-form", sermon: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#sermon-form", sermon: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/sermons")

      assert html =~ "Sermon updated successfully"
      assert html =~ "some updated references"
    end

    test "deletes sermon in listing", %{conn: conn, sermon: sermon} do
      {:ok, index_live, _html} = live(conn, ~p"/sermons")

      assert index_live |> element("#sermons-#{sermon.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#sermon-#{sermon.id}")
    end
  end

  describe "Show" do
    setup [:create_sermon]

    test "displays sermon", %{conn: conn, sermon: sermon} do
      {:ok, _show_live, html} = live(conn, ~p"/sermons/#{sermon}")

      assert html =~ "Show Sermon"
      assert html =~ sermon.references
    end

    test "updates sermon within modal", %{conn: conn, sermon: sermon} do
      {:ok, show_live, _html} = live(conn, ~p"/sermons/#{sermon}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Sermon"

      assert_patch(show_live, ~p"/sermons/#{sermon}/show/edit")

      assert show_live
             |> form("#sermon-form", sermon: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#sermon-form", sermon: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/sermons/#{sermon}")

      assert html =~ "Sermon updated successfully"
      assert html =~ "some updated references"
    end
  end
end
