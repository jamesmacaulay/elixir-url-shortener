defmodule PhoenixUrlShortener.ShortcutController do
  use PhoenixUrlShortener.Web, :controller

  alias PhoenixUrlShortener.Shortcut

  plug :scrub_params, "shortcut" when action in [:create]

  def create(conn, %{"shortcut" => shortcut_params}) do
    changeset = Shortcut.changeset(%Shortcut{}, shortcut_params)

    case Repo.insert(changeset) do
      {:ok, shortcut} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", shortcut_path(conn, :show, shortcut))
        |> render("show.json", shortcut: shortcut)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PhoenixUrlShortener.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def redirect_to_target(conn, %{"slug" => slug}) do
    shortcut = Repo.one!(from s in Shortcut, where: s.slug == ^slug)
    redirect(conn, external: shortcut.target_url)
  end
end
