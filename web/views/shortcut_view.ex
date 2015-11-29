defmodule PhoenixUrlShortener.ShortcutView do
  use PhoenixUrlShortener.Web, :view

  def render("index.json", %{shortcuts: shortcuts}) do
    %{data: render_many(shortcuts, PhoenixUrlShortener.ShortcutView, "shortcut.json")}
  end

  def render("show.json", %{shortcut: shortcut}) do
    %{data: render_one(shortcut, PhoenixUrlShortener.ShortcutView, "shortcut.json")}
  end

  def render("shortcut.json", %{shortcut: shortcut}) do
    %{slug: shortcut.slug,
      target_url: shortcut.target_url}
  end
end
