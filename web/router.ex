defmodule Sq2.Router do
  use Sq2.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    resources "/games", Sq2.GameController, except: [:new, :edit]
    resources "/boards", Sq2.BoardController, except: [:new, :edit, :show]
    resources "/players", Sq2.PlayerController, except: [:new, :edit]
    resources "/roles", Sq2.RoleController, except: [:new, :edit]
  end

  scope "/", Sq2 do
    pipe_through :browser # Use the default browser stack

    get "/", GameController, :join
    get "/boards/:board_slug", BoardController, :display
    get "/admin", AdminController, :index
    get "/admin/supervise_game/:game_id", AdminController, :supervise_game
    get "/join", GameController, :join
    post "/join", GameController, :join
    #TODO shouldn't be GET
    get "/admin/games/:game_id/set_active_board/:board_id", AdminController, :set_active_board
    get "/admin/boards/:board_id/trim_disconnected_players", AdminController, :trim_disconnected_players
    #must be last
    get "/:board_slug", BoardController, :play
  end

  # Other scopes may use custom stacks.
  # scope "/api", Sq2 do
  #   pipe_through :api
  # end
end
