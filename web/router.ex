defmodule Main.Router do
  use Main.Web, :router
  use Coherence.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session
  end

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, protected: true  # Add this
  end

  scope "/" do
    pipe_through :browser
    coherence_routes
  end

  scope "/" do
    pipe_through :protected
    coherence_routes :protected

    get "/app", Main.AppController, :index
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Main do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/offices", OfficeController
  end

  #Other scopes may use custom stacks.
  scope "/api", Main do
    pipe_through :api

    scope "/v1", as: :v1 do
      resources "/offices", Api.V1.OfficeController, only: [:index, :show]
    end
  end
end
