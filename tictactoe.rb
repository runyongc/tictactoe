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
		board.compact.size == 9 && winner.nil? || board.compact.size == 16 && winner.nil?
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
		if board.length == 9
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
		 	  board[positions[0]] ) || nil }.compact.first
		elsif board.length == 16
			@winner ||= [
		     # horizontal wins
		     [0, 1, 2, 3],
		     [4, 5, 6, 7],
		     [8, 9, 10, 11],
		     [12, 13, 14, 15],

		     # vertical wins
		     [0, 4, 8, 12],
		     [1, 5, 9, 13],
		     [2, 6, 10, 14],
		     [3, 7, 11, 15],

		     # diagonal wins
		     [0, 5, 10, 15],
		     [12, 9, 6, 3]
		 ].collect { |positions| 
		 	( board[positions[0]] == board[positions[1]] &&
		 	  board[positions[1]] == board[positions[2]] && 
		 	  board[positions[2]] == board[positions[3]] && 
		 	  board[positions[0]]) || nil }.compact.first
		end
	end
end

class GameTree
	def generate(gridsize)
			@loading = 1
			array = gridsize
			@length = array.length
			p "Loading board with gridsize #{@length}"
			initial_game_state = GameState.new('X', array)
			generate_moves(initial_game_state)
			initial_game_state
	end

	def generate_moves(game_state)
		next_player = (game_state.current_player == 'X' ? 'O' : 'X')
		game_state.board.each_with_index do |player_at_position, position|
			unless player_at_position
				next_board = game_state.board.dup
				next_board[position] = game_state.current_player
				@loading = (@loading + 1)
				p "loading, recursions #{@loading} length is #{@length} moves #{game_state.rank}"
				next_game_state = GameState.new(next_player, next_board)
				game_state.moves << next_game_state
				generate_moves(next_game_state)
			end
		end
	end
end

class TicTacToe
	attr_accessor :currentBoard, :difficulty, :game_state, :gridsize
	def initialize(difficulty, gridsize)
		@difficulty = difficulty
		@gridsize = gridsize
		setupGame
		@currentBoard = @game_state.board
	end

	def setupGame
		if @difficulty == "hard" && @gridsize == "4"
			@game_state = @initial_game_state = GameTree.new.generate(Array.new(16))
			ai_move
		elsif @difficulty == "hard" && @gridsize == "3"
			@game_state = @initial_game_state = GameTree.new.generate(Array.new(9))
			ai_move
		elsif @difficulty == "easy" && @gridsize == "3"
			@game_state = GameState.new('X', Array.new(9))
		elsif @difficulty == "easy" && @gridsize == "4"
			@game_state = GameState.new('X', Array.new(12))
		end

	end

	def ai_move
		if @game_state.current_player == 'X' && @difficulty == "hard"
			@game_state = @game_state.next_move
			render_board
		end
	end

	def player_move(string)
		move = string.to_i
		if @difficulty == 'hard'
			@game_state.moves.find{ |game_state| game_state.board[move.to_i] == 'O' }
		else 
			@currentBoard[move] = 'O'
		end
	end

	def available_spaces
		available = []
		@currentBoard.each_index do |ndx|
			available << ndx if @currentBoard[ndx].nil?
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

	def finalize_ai_move
		place_piece(board, @best_choice, "X")
	end

	def render_board
		@currentBoard = @game_state.board
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
	
	def playGame(string)
		hard_difficulty_round(string)
		easy_difficulty_round(string)
	end
end






