defmodule PulpitWeb.SermonLive.Index do
  use PulpitWeb, :live_view

  alias Pulpit.Resources
  alias Pulpit.Resources.Sermon

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    {:ok, assign(socket, :sermons, list_sermons(user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    user = socket.assigns.current_user

    socket
    |> assign(:page_title, "Edit Sermon")
    |> assign(:sermon, Resources.get_user_sermon!(user, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Sermon")
    |> assign(:sermon, %Sermon{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Sermons")
    |> assign(:sermon, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user = socket.assigns.current_user
    sermon = Resources.get_user_sermon!(user, id)
    {:ok, _} = Resources.delete_sermon(sermon)

    {:noreply, assign(socket, :sermons, list_sermons(user))}
  end

  defp list_sermons(user) do
    Resources.list_user_sermons(user)
  end
end
