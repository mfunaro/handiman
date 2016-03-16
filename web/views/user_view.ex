defmodule Handiman.UserView do
  use JSONAPI.View
  alias Handiman.UserView

  def render("index.json", %{users: users, conn: conn, params: params}) do
    UserView.index(users, conn, params)
  end

  def render("show.json", %{user: user, conn: conn, params: params}) do
    UserView.show(user, conn, params)
  end

  def fields(), do: [:first_name, :last_name, :email]
  def type(), do: "user"
end
