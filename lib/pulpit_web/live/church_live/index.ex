defmodule PulpitWeb.ChurchLive.Index do
  use PulpitWeb, :live_view

  alias Pulpit.Directory
  alias Pulpit.Directory.Church

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    {:ok, assign(socket, :churches, list_churches(user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Church")
    |> assign(:church, Directory.get_church!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Church")
    |> assign(:church, %Church{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Churches")
    |> assign(:church, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user = socket.assigns.current_user
    church = Directory.get_church!(id)
    {:ok, _} = Directory.delete_church(church)

    {:noreply, assign(socket, :churches, list_churches(user))}
  end

  defp list_churches(user) do
    Directory.list_user_churches(user)
  end
end
