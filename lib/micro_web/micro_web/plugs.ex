defmodule MicroWeb.Plugs do
  import Plug.Conn


  def fetch_user(conn, _opts) do
    user_id = get_session(conn, :user_id)
    if user_id do
      user = Micro.Accounts.get_user!(user_id)
      assign(conn, :current_user, user)
    else
      assign(conn, :current_user, nil)
    end
  end
end
