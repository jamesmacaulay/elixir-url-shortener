defmodule PhoenixUrlShortener.ShortcutControllerTest do
  use PhoenixUrlShortener.ConnCase

  alias PhoenixUrlShortener.Shortcut
  @valid_attrs %{slug: "foo", target_url: "http://www.example.com"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, shortcut_path(conn, :create), shortcut: @valid_attrs
    assert json_response(conn, 201)["data"] == %{
      "short_url" => shortcut_url(conn, :redirect_to_target, @valid_attrs.slug),
      "target_url" => @valid_attrs.target_url
    }
    assert Repo.get_by(Shortcut, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, shortcut_path(conn, :create), shortcut: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "redirects to target URL" do
    shortcut = Repo.insert! Shortcut.changeset(%Shortcut{}, @valid_attrs)
    conn = get conn, shortcut_path(conn, :redirect_to_target, shortcut)
    assert response(conn, 302)
  end
end
