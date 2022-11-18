defmodule PulpitWeb.SermonLive.Show do
  use PulpitWeb, :live_view

  alias Pulpit.Resources

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:sermon, Resources.get_sermon!(id))}
  end

  defp page_title(:show), do: "Show Sermon"
  defp page_title(:edit), do: "Edit Sermon"
end
