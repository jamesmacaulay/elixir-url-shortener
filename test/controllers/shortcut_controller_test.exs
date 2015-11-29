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
    shortcut = Repo.insert! Shortcut.changeset(%Shortcut{}, @valid_attrs)
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

  test "redirects to target URL" do
    shortcut = Repo.insert! Shortcut.changeset(%Shortcut{}, @valid_attrs)
    conn = get conn, shortcut_path(conn, :redirect_to_target, shortcut.slug)
    assert response(conn, 302)
  end
end
