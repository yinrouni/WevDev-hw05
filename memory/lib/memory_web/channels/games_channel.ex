defmodule MemoryWeb.GamesChannel do
  use MemoryWeb, :channel
	alias Memory.Game
	alias Memory.BackupAgent

 def join("games:" <> name, payload, socket) do
    if authorized?(payload) do
     	game = BackupAgent.get(name) || Game.new()
			BackupAgent.put(name, game)
			socket = socket
			|> assign(:game, game)
			|> assign(:name, name)
			{:ok, %{"join" => name, "game" => Game.client_view(game)}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

def handle_in("click", %{"index"=> i}, socket) do
	name = socket.assigns[:name]
	game = Game.handle_click(socket.assigns[:game], i)
	socket = assign(socket, :game, game)
	BackupAgent.put(name, game)
    {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
  end	

def handle_in("reset", %{}, socket) do 
	name = socket.assigns[:name]
	game = Game.reset(socket.assigns[:game])
	socket = assign(socket, :game, game)
	BackupAgent.put(name, game)
    {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
  end	

def handle_in("match", %{}, socket) do 
	name = socket.assigns[:name]
	game = Game.matched(socket.assigns[:game])
	socket = assign(socket, :game, game)
	BackupAgent.put(name, game)
    {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
  end

def handle_in("not_match", %{}, socket) do 
	name = socket.assigns[:name]
	game = Game.not_match(socket.assigns[:game])
	socket = assign(socket, :game, game)
	BackupAgent.put(name, game)
    {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (games:lobby).

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
