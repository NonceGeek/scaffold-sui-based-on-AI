defmodule ScaffoldSuiBasedOnAIWeb.PageController do
  use ScaffoldSuiBasedOnAIWeb, :controller

  def home(conn, _params) do
    render(conn, :home, active_tab: :home)
  end
end
