require "minitest/autorun"
require_relative "tictactoe.rb"

class TestTicTacToe < MiniTest::Test
	def test_assert_that_1_equals_1
		assert_equal(1,1)
	end
	def test_winner_player
		game = TicTacToe.new
		testarray = ["O","O","O","O","O","O","O","O"]
		assert_equal(true, game.gameOver?(testarray))
	end
	def test_winner_ai
		game = TicTacToe.new
		testarray = ["X","X","X","X","X","X","X","X"]
		assert_equal(true, game.gameOver?(testarray))
	end
	def test_winner_nil
		game = TicTacToe.new
		testarray = ["y","a","s","f","q","t","n","m"]
		assert_nil(nil, game.gameOver?(testarray))
	end
	def test_ai_move
		game = TicTacToe.new
		testarray = ["X","X",0,0,0,0,0,0]
		assert_equal(2, game.ai_move(testarray))
	end
end