defmodule PhoenixUrlShortener.ShortcutView do
  use PhoenixUrlShortener.Web, :view

  def render("index.json", %{conn: conn, shortcuts: shortcuts}) do
    %{data: render_many(shortcuts, PhoenixUrlShortener.ShortcutView, "shortcut.json", conn: conn)}
  end

  def render("show.json", %{conn: conn, shortcut: shortcut}) do
    %{data: render_one(shortcut, PhoenixUrlShortener.ShortcutView, "shortcut.json", conn: conn)}
  end

  def render("shortcut.json", %{conn: conn, shortcut: shortcut}) do
    %{short_url: shortcut_url(conn, :redirect_to_target, shortcut),
      target_url: shortcut.target_url}
  end
end
