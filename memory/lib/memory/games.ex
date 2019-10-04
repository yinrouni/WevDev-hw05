defmodule Memory.Game do 
  def new() do
    %{
      letters: Enum.shuffle(["A", "B", "C", "D", "E", "F", "G", "H", "A", "B", "C","D", "E", "F", "G", "H"]),
      first: nil,
      second: nil, 
      clicks: 0,
      clickDisabled: false,
      present: [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 
nil, nil, nil, nil, nil]}
  end
  
  def client_view(game) do 
    l = game.letters
    s= game.second
    p = game.present
    c= game.clicks
   cd = game.clickDisabled
   f = game.first
    
    %{
      letters: l,
      second: s,
      present: p,
      clicks: c,
      clickDisabled: cd, first: f
  }
  end  

 def reset(game) do 
   new()
 end

 def handle_click(game, index) do
     clicks = game.clicks + 1
     letters = game.letters
     present = game.present
     first = game.first
     second = game.second

     newPresent = List.replace_at(present, index, Enum.at(letters, index))

     if (first == nil) do 
	Map.put(game, :clicks, clicks)
	|> Map.put(:present, newPresent)
	|> Map.put(:first, index)

     else 
       	Map.put(game, :clicks, clicks)
	|> Map.put(:present, newPresent)
	|> Map.put(:second, index)
     	|> Map.put(:clickDisabled, true)
   end
end

  def check_match(game) do
   if (game.first != nil && game.second != nil) do 
    if (Enum.at(game.letters, game.first) == Enum.at(game.letters, game.second)) do
	matched (game)
   else
       :timer.sleep(1000); 
       not_match(game)
   end
  end
end 
  
  def matched (game) do 
    game
    |> Map.put(:first, nil)
    |> Map.put(:second, nil)
    |> Map.put(:clickDisabled, false)
  end


  def not_match (game) do 
    first = game.first
    second= game.second
    present = List.replace_at(game.present, first, nil)
    newPresent = List.replace_at(present, second, nil)
    game 
    |> Map.put(:first, nil)
    |> Map.put(:second, nil)
    |> Map.put(:present, newPresent)
    |> Map.put(:clickDisabled, false)

  end
end
