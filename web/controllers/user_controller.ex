defmodule Handiman.UserController do
  use Handiman.Web, :controller

  alias Handiman.User

  plug :scrub_params, "data" when action in [:update]

  def index(conn, params) do
    users = Repo.all(User)
    render(conn, "index.json", %{users: users, conn: conn, params: params})
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.json", %{user: user, conn: conn, params: id})
  end

  def update(conn, %{"id" => id, "data" => %{ "type" => "user", "attributes" => user_params}}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", %{user: user, conn: conn, params: user_params})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Handiman.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def update(conn, _)  do
    conn
    |> put_status(:unprocessable_entity)
    |> render(Handiman.ChangesetView, "error.json", changeset: %{error: "invalid data"})
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end
end
