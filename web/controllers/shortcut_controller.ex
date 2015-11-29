defmodule PhoenixUrlShortener.ShortcutController do
  use PhoenixUrlShortener.Web, :controller

  alias PhoenixUrlShortener.Shortcut

  plug :scrub_params, "shortcut" when action in [:create, :update]

  def index(conn, _params) do
    shortcuts = Repo.all(Shortcut)
    render(conn, "index.json", shortcuts: shortcuts)
  end

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

  def show(conn, %{"id" => id}) do
    shortcut = Repo.get!(Shortcut, id)
    render(conn, "show.json", shortcut: shortcut)
  end

  def redirect_to_target(conn, %{"shortcut_slug" => slug}) do
    shortcut = Repo.one!(from s in Shortcut, where: s.slug == ^slug)
    redirect(conn, external: shortcut.target_url)
  end
end
