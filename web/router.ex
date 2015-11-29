defmodule PhoenixUrlShortener.Router do
  use PhoenixUrlShortener.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  get "/s/:slug", PhoenixUrlShortener.ShortcutController, :redirect_to_target

  scope "/api", PhoenixUrlShortener do
    pipe_through :api

    resources "/shortcuts", ShortcutController, param: "slug", only: [:index, :create, :show]
  end
end
