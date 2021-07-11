defmodule Todo.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias Todo.Repo
  alias Todo.Task
  import Ecto.Query

  schema "tasks" do
    field :is_completed, :boolean, default: false
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :is_completed])
    |> validate_required([:title, :is_completed])
  end

  def list_all() do
    Repo.all(from t in Task, order_by: t.id)
  end

  def get_task!(id), do: Repo.get!(Task, id)

  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end
end
