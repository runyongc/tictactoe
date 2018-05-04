class TicTacToe
	attr_accessor :currentBoard, :aiMove, :difficulty, :winner
	def initialize(difficulty)
		@currentBoard = [0, 0, 0,
						 0, 0, 0,
						 0, 0, 0]
		@winner = nil
		@difficulty = difficulty
	end

	def player_move(string)
		move = string.to_i
		@currentBoard[move] = "O"
	end

	def ai_move_offense(array)
		@aiMoveOffense = nil
		array.each.with_index do |element, ndx|
			if array[ndx] == 0
				clonedArray = array.dup
				clonedArray[ndx] = "X"
				if gameOver?(clonedArray) != nil
					@aiMoveOffense = ndx
					break
				end
			end		
		end
	end


	def ai_move_defense(array)
		@aiMoveDefense = nil
		array.each.with_index do |element, ndx|
			if array[ndx] == 0
				clonedArray = array.dup
				clonedArray[ndx] = "O"
				if gameOver?(clonedArray) != nil
					@aiMoveDefense = ndx
					break
				end
			end		
		end
	end

	def finalize_ai_move
		if @currentBoard[4] == 0
			@aiMoveOffense = nil
			@aiMoveDefense = nil
			@currentBoard[4] = "X"
		elsif @aiMoveOffense != nil
			@currentBoard[@aiMoveOffense] = "X"
		elsif @aiMoveOffense == nil && @aiMoveDefense != nil
			@currentBoard[@aiMoveDefense] = "X"
		elsif @currentBoard[0] == 0 || @currentBoard[2] == 0 || @currentBoard[6] == 0 || @currentBoard[8] == 0
			if @currentBoard[0] == 0
				@currentBoard[0] = "X"
			elsif @currentBoard[2] == 0
					@currentBoard[2] = "X"
			elsif @currentBoard[6] == 0
				@currentBoard[6] = "X"
			elsif @currentBoard[8] == 0
				@currentBoard[8] = "X"
			end		
		else		
			@currentBoard.each.with_index do |element, ndx|
				if @currentBoard[ndx] == 0
					@currentBoard[ndx] = "X"
					break
				end
			end
		end
	end

	def ai_move_easy
		if @difficulty == "easy"
			@currentBoard.each.with_index do |element, ndx|
				if @currentBoard[ndx] == 0
					@currentBoard[ndx] = "X"
					break
				end
			end
		end
	end

	def hard_difficulty_round(string)
		if @difficulty == "hard" && gameOver?(@currentBoard) == nil
			player_move(string)
			ai_move_offense(@currentBoard)
			ai_move_defense(@currentBoard)
			finalize_ai_move
		end
	end

	def easy_difficulty_round(string)
		if @difficulty == "easy" && gameOver?(@currentBoard) == nil
			player_move(string)
			ai_move_easy
		end
	end


	def gameOver?(array)
		if 
		# horizontal wins
			array[0] == "X" && array[1] == "X" && array[2] == "X" ||
			array[3] == "X" && array[4] == "X" && array[5] == "X" ||
			array[6] == "X" && array[7] == "X" && array[8] == "X" ||

		# vertical wins
			array[0] == "X" && array[3] == "X" && array[6] == "X" ||
			array[1] == "X" && array[4] == "X" && array[7] == "X" ||
			array[2] == "X" && array[5] == "X" && array[8] == "X" ||
		# diagonal wins

			array[0] == "X" && array[4] == "X" && array[8] == "X" ||
			array[2] == "X" && array[4] == "X" && array[6] == "X"
			@winner = "ai"
		elsif
			# horizontal wins
			array[0] == "O" && array[1] == "O" && array[2] == "O" ||
			array[3] == "O" && array[4] == "O" && array[5] == "O" ||
			array[6] == "O" && array[7] == "O" && array[8] == "O" ||

		# vertical wins
			array[0] == "O" && array[3] == "O" && array[6] == "O" ||
			array[1] == "O" && array[4] == "O" && array[7] == "O" ||
			array[2] == "O" && array[5] == "O" && array[8] == "O" ||
		# diagonal wins

			array[0] == "O" && array[4] == "O" && array[8] == "O" ||
			array[2] == "O" && array[4] == "O" && array[6] == "O"
			@winner = "player"
		elsif @currentBoard.count(0) <= 1
			puts array.include?(0)
			@winner = "draw"
		else 
			return nil
		end
	end

	def playGame(string)
		hard_difficulty_round(string)
		easy_difficulty_round(string)
		gameOver?(@currentBoard)
	end
end




