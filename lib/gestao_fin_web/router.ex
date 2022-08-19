defmodule GestaoFinWeb.Router do
  use GestaoFinWeb, :router

  import GestaoFinWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {GestaoFinWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  # coveralls-ignore-start
  pipeline :api do
    plug :accepts, ["json"]
  end

  # coveralls-ignore-stop

  scope "/", GestaoFinWeb do
    pipe_through [:browser, :require_authenticated_user]

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

  # coveralls-ignore-start

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

  # coveralls-ignore-stop

  ## Authentication routes

  scope "/", GestaoFinWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", GestaoFinWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", GestaoFinWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
