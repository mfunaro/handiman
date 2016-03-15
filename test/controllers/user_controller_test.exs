defmodule Handiman.UserControllerTest do
  use Handiman.ConnCase

  alias Handiman.User
  @valid_attrs %{ type: "user", attributes: %{first_name: "test_first_name",
                                              last_name: "test_last_name",
                                              email: "test_email",
                                              encrypted_password: "encrypted_password"}}
  @create_valid_attrs %{ type: "users", attributes: %{first_name: "test_first_name",
                                                      last_name: "test_last_name",
                                                      email: "test_email",
                                                      encrypted_password: "encrypted_password"}}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

   test "lists all entries on index", %{conn: conn} do
     conn = get conn, user_path(conn, :index)
     assert json_response(conn, 200)["data"] == []
   end

   test "shows chosen resource", %{conn: conn} do
     user = Repo.insert! %User{first_name: "first_name", last_name: "last_name", email: "email",
                               encrypted_password: "encrypted_password"}
     conn = get conn, user_path(conn, :show, user)
     assert String.to_integer(json_response(conn, 200)["data"]["id"]) == user.id
   end

   test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
     assert_raise Ecto.NoResultsError, fn ->
       get conn, user_path(conn, :show, -1)
     end
   end

   test "creates and renders resource when data is valid", %{conn: conn} do
     conn = post conn, user_path(conn, :create), data: @create_valid_attrs
     assert json_response(conn, 201)["data"]["id"]
     assert Repo.get_by(User, @create_valid_attrs.attributes)
   end

   test "does not create resource and renders errors when data is invalid", %{conn: conn} do
     conn = post conn, user_path(conn, :create), data: @invalid_attrs
     assert json_response(conn, 422)["errors"] != %{}
   end

   test "updates and renders chosen resource when data is valid", %{conn: conn} do
     user = Repo.insert! %User{}
     conn = put conn, user_path(conn, :update, user), %{id: user.id, data: @valid_attrs}
     assert json_response(conn, 200)["data"]["id"]
     assert Repo.get_by(User, @valid_attrs.attributes)
   end

   test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
     user = Repo.insert! %User{}
     conn = put conn, user_path(conn, :update, user), data: @invalid_attrs
     assert json_response(conn, 422)["errors"] != %{}
   end

   test "deletes chosen resource", %{conn: conn} do
     user = Repo.insert! %User{}
     conn = delete conn, user_path(conn, :delete, user)
     assert response(conn, 204)
     refute Repo.get(User, user.id)
   end
end
