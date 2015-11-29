defmodule PhoenixUrlShortener.ShortcutControllerTest do
  use PhoenixUrlShortener.ConnCase

  alias PhoenixUrlShortener.Shortcut
  @valid_attrs %{slug: "foo", target_url: "http://www.example.com"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, shortcut_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    shortcut = Repo.insert! %Shortcut{}
    conn = get conn, shortcut_path(conn, :show, shortcut)
    assert json_response(conn, 200)["data"] == %{"id" => shortcut.id,
      "slug" => shortcut.slug,
      "target_url" => shortcut.target_url}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, shortcut_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, shortcut_path(conn, :create), shortcut: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Shortcut, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, shortcut_path(conn, :create), shortcut: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    shortcut = Repo.insert! %Shortcut{}
    conn = put conn, shortcut_path(conn, :update, shortcut), shortcut: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Shortcut, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    shortcut = Repo.insert! %Shortcut{}
    conn = put conn, shortcut_path(conn, :update, shortcut), shortcut: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    shortcut = Repo.insert! %Shortcut{}
    conn = delete conn, shortcut_path(conn, :delete, shortcut)
    assert response(conn, 204)
    refute Repo.get(Shortcut, shortcut.id)
  end
end
