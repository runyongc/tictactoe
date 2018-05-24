require "minitest/autorun"
require_relative "tictactoe.rb"

class TestTicTacToe < MiniTest::Test
	def test_assert_that_1_equals_1
		assert_equal(1,1)
	end
	def test_winner_ai_3x3
		testarray = ["O","O","O",nil,nil,nil,nil,nil,nil]
		game = GameState.new("O", testarray)
		assert_equal("p", game.winner)
	end
	def test_winner_player_3x3
		testarray = ["X","X","X",nil,nil,nil,nil,nil,nil]
		game = GameState.new("X", testarray)
		assert_equal("o", game.winner)
	end
	def test_winner_nil_3x3
		testarray = ["X","X","X","X","X","X","X","X","X"]
		game = GameState.new("X", testarray)
		assert_nil(nil, game.winner)
	end
	def test_winner_ai_4x4
		testarray = [nil,"O",nil,nil,
					 nil,"O",nil,nil,
					 nil,"O",nil,nil,
					 nil,"O",nil,nil]
		game = GameState.new("O", testarray)
		assert_equal("O", game.winner)
	end
	def test_winner_player_4x4
		testarray = [nil,"X",nil,nil,
					 nil,"X",nil,nil,
					 nil,"X",nil,nil,
					 nil,"X",nil,nil]
		game = GameState.new("X", testarray)
		assert_equal("X", game.winner)
	end
	def test_winner_nil_4x4
		testarray = ["y","a","s","f","q","t","n","m","s","a","t","y","u","q","i","p"]
		game = GameState.new("X", testarray)
		assert_nil(nil, game.winner)
	end

	def test_gameover
		game = GameState.new("X", Array.new(9))
		assert_equal(0, game.winner)
	end
end