defmodule PhoenixUrlShortener.ShortcutTest do
  use PhoenixUrlShortener.ModelCase

  alias PhoenixUrlShortener.Shortcut

  @valid_attrs %{slug: "foo", target_url: "https://www.example.com/"}

  test "changeset with valid attributes" do
    changeset = Shortcut.changeset(%Shortcut{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with empty attributes is invalid" do
    changeset = Shortcut.changeset(%Shortcut{}, %{})
    refute changeset.valid?
    assert changeset.errors == [target_url: "can't be blank"]
  end

  test "changeset with no slug generates a slug" do
    changeset = Shortcut.changeset(%Shortcut{}, Map.delete(@valid_attrs, :slug))
    assert changeset.valid?
    assert Map.has_key?(changeset.changes, :slug)
  end

  test "changeset with a non-http(s) URL is invalid" do
    changeset = Shortcut.changeset(%Shortcut{}, %{target_url: "ftp://example.com"})
    refute changeset.valid?
    assert changeset.errors == [target_url: "must be an http or https URL"]
  end
end
