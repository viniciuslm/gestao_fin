defmodule GestaoFinWeb.Router do
  use GestaoFinWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {GestaoFinWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GestaoFinWeb do
    pipe_through :browser

    live "/pagar", Contas.PagarLive, :index
    live "/pagar/new", Contas.PagarLive, :new
    live "/pagar/:id/edit", Contas.PagarLive, :edit
    live "/pagar/:id/delete", Contas.PagarLive, :delete
    live "/receber", Contas.ReceberLive, :index
    live "/receber/new", Contas.ReceberLive, :new
    live "/receber/:id/edit", Contas.ReceberLive, :edit
    live "/receber/:id/delete", Contas.ReceberLive, :delete
    live "/categoria", CategoriaLive, :index
    live "/categoria/new", CategoriaLive, :new
    live "/categoria/:id/edit", CategoriaLive, :edit
    live "/categoria/:id/delete", CategoriaLive, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", GestaoFinWeb do
  #   pipe_through :api
  # end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
