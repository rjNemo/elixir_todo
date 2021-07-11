defmodule TodoWeb.TodoLive do
  use TodoWeb, :live_view

  alias Todo.Task
  alias Todo.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, all_tasks: Task.list_all())}
  end

  defp fetch(socket, task) do
    assign(socket, all_tasks: Task.list_all(), task: task)
  end

  defp fetch(socket) do
    assign(socket, all_tasks: Task.list_all())
  end

  def handle_event("add", %{"task" => task}, socket) do
    changeset = Task.changeset(%Task{}, task)

    case Repo.insert(changeset) do
      {:ok, _model} ->
        {:noreply, fetch(socket)}

      {:error, task} ->
        {:noreply, fetch(socket, task: task)}
    end
  end

  @impl true
  def handle_event("toggle_completed", %{"id" => id}, socket) do
    task = Task.get_task!(id)
    Task.update_task(task, %{is_completed: !task.is_completed})
    {:noreply, fetch(socket)}
  end
end
