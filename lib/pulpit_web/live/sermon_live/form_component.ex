defmodule PulpitWeb.SermonLive.FormComponent do
  use PulpitWeb, :live_component

  alias Pulpit.Resources

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage sermon records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="sermon-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :title}} type="text" label="Title" />
        <.input field={{f, :references}} type="textarea" label="References" />
        <.input field={{f, :written_at}} type="datetime-local" label="Date written" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Sermon</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{sermon: sermon} = assigns, socket) do
    changeset = Resources.change_sermon(sermon)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"sermon" => sermon_params}, socket) do
    changeset =
      socket.assigns.sermon
      |> Resources.change_sermon(sermon_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"sermon" => sermon_params}, socket) do
    save_sermon(socket, socket.assigns.action, sermon_params)
  end

  defp save_sermon(socket, :edit, sermon_params) do
    case Resources.update_sermon(socket.assigns.sermon, sermon_params) do
      {:ok, _sermon} ->
        {:noreply,
         socket
         |> put_flash(:info, "Sermon updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_sermon(socket, :new, sermon_params) do
    user = socket.assigns.current_user

    case Resources.create_sermon(user, sermon_params) do
      {:ok, _sermon} ->
        {:noreply,
         socket
         |> put_flash(:info, "Sermon created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
