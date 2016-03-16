defmodule Handiman.RegistrationController do
  use Handiman.Web, :controller
  import Ecto.Changeset, only: [put_change: 3]
  alias Handiman.User
  alias Handiman.UserView

  plug :scrub_params, "data" when action in [:create]

  def create(conn, %{"data" => %{ "type" => "user", "attributes" => user_params}}) do
    changeset = User.changeset(%User{}, user_params)
    repo_return = changeset
                    |> put_change(:encrypted_password, hashed_password(changeset.params["password"]))
                    |> Repo.insert
    case repo_return do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render(Handiman.UserView, "show.json", %{user: user, conn: conn, params: user_params})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Handiman.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def create(conn, _)  do
    conn
    |> put_status(:unprocessable_entity)
    |> render(Handiman.ChangesetView, "error.json", changeset: %{error: "invalid data"})
  end

  defp hashed_password(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end
end
