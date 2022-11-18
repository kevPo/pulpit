defmodule PulpitWeb.ChurchLive.FormComponent do
  use PulpitWeb, :live_component

  alias Pulpit.Directory

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage church records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="church-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :name}} type="text" label="Church name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Church</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{church: church} = assigns, socket) do
    changeset = Directory.change_church(church)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"church" => church_params}, socket) do
    changeset =
      socket.assigns.church
      |> Directory.change_church(church_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"church" => church_params}, socket) do
    save_church(socket, socket.assigns.action, church_params)
  end

  defp save_church(socket, :edit, church_params) do
    case Directory.update_church(socket.assigns.church, church_params) do
      {:ok, _church} ->
        {:noreply,
         socket
         |> put_flash(:info, "Church updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_church(socket, :new, church_params) do
    user = socket.assigns.current_user

    case Directory.create_church(user, church_params) do
      {:ok, _church} ->
        {:noreply,
         socket
         |> put_flash(:info, "Church created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
