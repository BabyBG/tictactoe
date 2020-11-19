require 'pry'

class GameBoard
  attr_reader :tile_hash
  def initialize
    @grid_letter = ["a", "b", "c"]
    @grid_number = ["1", "2", "3"]
    #'@tile_hash' keys are the 9 grid coordinates, set with a "." (blank) value here
    @tile_hash = Hash[@grid_number.product(@grid_letter).map {|x| [x, "."]}]
  end
  #'show_board' outputs the grid graphic display to the console
  def show_board
    b = @tile_hash.values
    #'tile_array' groups grid square values (blank, "X", "O") within 3 nested arrays for easier graphical output
    tile_array = Array.new(3) {b.shift(3)}
    print "\t"
    print @grid_letter.join("\t")
    puts
    tile_array.each_with_index do |row, i|
      print @grid_number[i]
      print "\t"
      print row.join("\t")
      puts
    end 
  end
  #'assign_move' calls 'get_move' to get a valid move and changes @tile_hash value to either "X" or "O" (just X for now)
  def assign_move(player)
    @tile_hash[get_move] = player
  end
  #'three_in_sequence' looks for 3 values in sequence to check for a winner
  def three_in_sequence(occupied)
    match = false 
    d = occupied.keys
    o = d.join(" ").split.sort
    #searches rows & columns for a match
    o.each_with_index do |e, i|
      if (e == o[i+1]) && (e == o[i+2])
        match = true
      end
    end
    #this 'if' checks the diagonals for matches
    if (d.include?(["1", "a"]) && d.include?(["2", "b"]) && d.include?(["3", "c"])) ||
        (d.include?(["1", "c"]) && d.include?(["2", "b"]) && d.include?(["3", "a"]))
        match = true
    end
    return match   
  end
  #'self.game_round' is the Noughts & Crosses main game, organising several functions that loop until a winner is declared.
  def self.game_round
    player = "O"
    win = false
    board = GameBoard.new
    while win == false
      board.show_board
      board.assign_move(player)
      player == "O" ? player = "X" : player = "O"
      occupied_x = board.tile_hash.select {|_, v| v == "X"}
      occupied_o = board.tile_hash.select {|_, v| v == "O"}
      if board.three_in_sequence(occupied_x) == true
        win = true
        board.show_board
        puts "Crosses wins!"
      end
      if board.three_in_sequence(occupied_o) == true
        win = true
        board.show_board
        puts "Noughts wins!"
      end
      if board.tile_hash.values.none?(".") && winner == false
        win = true
        board.show_board
        puts "It's a draw!"
      end
    end
  end
end

#'get_move' asks player for grid coordinates & checks it is a valid move.
def get_move
  def ask_move
    move = gets.chomp.split(//).sort
    #checks move is correct length and contains a-c + 1-3.
    unless (move.length == 2 && (move.any?(/[a-c]/) && move.any?(/[1-3]/)))
      puts "Please enter only a NUMBER & LETTER from the grid, in the format 'a1' or '2b'"
      move = ask_move
    end    
    #checks that the 'move' chosen is currently blank (".").
    unless @tile_hash[move] == "."
      puts "Player piece already on that square! Please choose another."
      move = ask_move
    end
    return move
  end
  puts "Enter the letter and number of any free space to make your move eg. 'b3' or '1a'"
  ask_move
end

GameBoard.game_round