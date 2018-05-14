class GameState
  attr_accessor :current_player, :board, :moves, :rank

  def initialize(current_player, board)
    self.current_player = current_player
    self.board = board
    self.moves = []
  end
  
  def rank
    @rank ||= final_state_rank || intermediate_state_rank
  end

  def next_move
    moves.max{ |a, b| a.rank <=> b.rank }
  end

  def final_state_rank
    if final_state?
      return 0 if draw?
      winner == "X" ? 1 : -1
    end
  end

  def final_state?
    winner || draw?
  end

  def draw?
    board.compact.size == 9 && winner.nil?
  end

  def intermediate_state_rank
    ranks = moves.collect{ |game_state| game_state.rank }
    if current_player == 'X'
      ranks.max
    else
      ranks.min
    end
  end  

  def winner
    @winner ||= [
     # horizontal wins
     [0, 1, 2],
     [3, 4, 5],
     [6, 7, 8],

     # vertical wins
     [0, 3, 6],
     [1, 4, 7],
     [2, 5, 8],

     # diagonal wins
     [0, 4, 8],
     [6, 4, 2]
    ].collect { |positions|
      ( board[positions[0]] == board[positions[1]] &&
        board[positions[1]] == board[positions[2]] &&
        board[positions[0]] ) || nil
    }.compact.first
  end
end

class GameTree
  def generate
    initial_game_state = GameState.new('X', Array.new(9))
    generate_moves(initial_game_state)
    initial_game_state
  end

  def generate_moves(game_state)
    next_player = (game_state.current_player == 'X' ? 'O' : 'X')
    game_state.board.each_with_index do |player_at_position, position|
      unless player_at_position
        next_board = game_state.board.dup
        next_board[position] = game_state.current_player
        next_game_state = GameState.new(next_player, next_board)
        game_state.moves << next_game_state
        generate_moves(next_game_state)
      end
    end
  end
end

class TicTacToe
	attr_accessor :currentBoard, :difficulty, :game_state
	def initialize(difficulty)
		@game_state = @initial_game_state = GameTree.new.generate
		@difficulty = difficulty
		@currentBoard = @game_state.board
		ai_move
	end

	def ai_move
		if @game_state.current_player == 'X' && @difficulty == "hard"
      			@game_state = @game_state.next_move
      			render_board
    	end
    end


	def player_move(string)
		move = string.to_i
		@game_state.moves.find{ |game_state| game_state.board[move.to_i] == 'O' }

	end

	def available_spaces
		available = []
		@game_state.board.each_index do |ndx|
			available << ndx if array[ndx].nil?
		end
		available
	end

	def place_piece(board, space, current_player)
		board[space] = current_player
	end

	def winner
		if @game_state.winner == "X"
			return "X"
		elsif @game_state.winner
			return "O"
		elsif @game_state.draw?
			return "draw"
		end
	end


 #  	def minmax(player, board)
 #   		next_player = (switch(@current_player))
 #    	@currentBoard.each_with_index do |player_at_position, position|
 #    unless player_at_position
 #        next_board = @currentBoard.dup
 #        next_board[position] = @current_player

 #        next_game_state = minmax(next_player, next_board)
 #        moves << next_game_state
 #        minmax(next_game_state)
 #      	end
 #    end
 #  	end
	
	# def rank
 #    @rank ||= score(board) || collect_moves
 #  	end

 #    def collect_moves
 #    	ranks = moves.collect{ |move| move.rank }
 #    	if current_player == 'X'
 #      		ranks.max
 #    	else
 #      		ranks.min
 #    	end
 #  	end  

 #  	def next_move
 #    moves.max{ |a, b| a.rank <=> b.rank }
 #  	end

	# def score(board)
 #    	if gameOver?(board)
 #      		return 0 if tie?(board)
 #      		@winner == "X" ? 1 : -1
 #    	end
 #  	end

	# def switch(player)
	# 	player == "X" ? "O" : "X"
	# end

	def finalize_ai_move
		place_piece(board, @best_choice, "X")
	end
	# def ai_move_offense(array)
	# 	@aiMoveOffense = nil
	# 	array.each.with_index do |element, ndx|
	# 		if array[ndx] == 0
	# 			clonedArray = array.dup
	# 			clonedArray[ndx] = "X"
	# 			if gameOver?(clonedArray) != nil
	# 				@aiMoveOffense = ndx
	# 				break
	# 			end
	# 		end		
	# 	end
	# end


	# def ai_move_defense(array)
	# 	@aiMoveDefense = nil
	# 	array.each.with_index do |element, ndx|
	# 		if array[ndx] == 0
	# 			clonedArray = array.dup
	# 			clonedArray[ndx] = "O"
	# 			if gameOver?(clonedArray) != nil
	# 				@aiMoveDefense = ndx
	# 				break
	# 			end
	# 		end		
	# 	end
	# end

	# def finalize_ai_move
	# 	if @currentBoard[4] == 0
	# 		@aiMoveOffense = nil
	# 		@aiMoveDefense = nil
	# 		@currentBoard[4] = "X"
	# 	elsif @aiMoveOffense != nil
	# 		@currentBoard[@aiMoveOffense] = "X"
	# 	elsif @aiMoveOffense == nil && @aiMoveDefense != nil
	# 		@currentBoard[@aiMoveDefense] = "X"
	# 	elsif @currentBoard[0] == 0 || @currentBoard[2] == 0 || @currentBoard[6] == 0 || @currentBoard[8] == 0
	# 		if @currentBoard[0] == 0
	# 			@currentBoard[0] = "X"
	# 		elsif @currentBoard[2] == 0
	# 				@currentBoard[2] = "X"
	# 		elsif @currentBoard[6] == 0
	# 			@currentBoard[6] = "X"
	# 		elsif @currentBoard[8] == 0
	# 			@currentBoard[8] = "X"
	# 		end		
	# 	else		
	# 		@currentBoard.each.with_index do |element, ndx|
	# 			if @currentBoard[ndx] == 0
	# 				@currentBoard[ndx] = "X"
	# 				break
	# 			end
	# 		end
	# 	end
	# end

	def render_board
    	0.upto(8) do |position|
      @currentBoard[position] = @game_state.board[position]
      end
    end



	def ai_move_easy
		if @difficulty == "easy" && !@game_state.final_state?
			move = available_spaces.sample
			@currentBoard[move] = "X"
		end
	end

	def hard_difficulty_round(string)
		if @difficulty == "hard" && !@game_state.final_state?
    		move = @game_state.moves.find{ |game_state| game_state.board[string.to_i] == 'O' }
    		@game_state = move
    		ai_move
    		render_board
    	end
    end

	def easy_difficulty_round(string)
		if @difficulty == "easy" && !@game_state.final_state?
			ai_move_easy
			player_move(string)
		end
	end
	
	# def gameOver?(board)
 #        winner? || tie?
 #    end
	
	# def tie?(array)
	# 	available_spaces(board).empty?
	# end

	# def winner?(array)
	# 	if 
	# 	# horizontal wins
	# 		array[0] == "X" && array[1] == "X" && array[2] == "X" ||
	# 		array[3] == "X" && array[4] == "X" && array[5] == "X" ||
	# 		array[6] == "X" && array[7] == "X" && array[8] == "X" ||

	# 	# vertical wins
	# 		array[0] == "X" && array[3] == "X" && array[6] == "X" ||
	# 		array[1] == "X" && array[4] == "X" && array[7] == "X" ||
	# 		array[2] == "X" && array[5] == "X" && array[8] == "X" ||
	# 	# diagonal wins

	# 		array[0] == "X" && array[4] == "X" && array[8] == "X" ||
	# 		array[2] == "X" && array[4] == "X" && array[6] == "X"
	# 		@winner = "X"
	# 	elsif
	# 		# horizontal wins
	# 		array[0] == "O" && array[1] == "O" && array[2] == "O" ||
	# 		array[3] == "O" && array[4] == "O" && array[5] == "O" ||
	# 		array[6] == "O" && array[7] == "O" && array[8] == "O" ||

	# 	# vertical wins
	# 		array[0] == "O" && array[3] == "O" && array[6] == "O" ||
	# 		array[1] == "O" && array[4] == "O" && array[7] == "O" ||
	# 		array[2] == "O" && array[5] == "O" && array[8] == "O" ||
	# 	# diagonal wins

	# 		array[0] == "O" && array[4] == "O" && array[8] == "O" ||
	# 		array[2] == "O" && array[4] == "O" && array[6] == "O"
	# 		@winner = "O"
	# 	end
	# end

	def playGame(string)
		hard_difficulty_round(string)
		easy_difficulty_round(string)
	end
end






