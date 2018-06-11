class PerfectComputer

  def choose_space(game)
    @best_score = {}
    negamax(game)
    p @best_score.inspect
    @best_score.max_by(&:last).first

  end

  private

  def negamax(game, depth = 0, alpha = -1000, beta = 1000, color = 1)

    return color * score_scenarios(depth, game) if game.game_over?

    max = -1000

    game.check_available_spaces.each do |space|
      if depth >= 9
        break
      end
      game.board[space] = game.current_player
      game.current_player = game.current_player == 'X' ? 'O' : 'X'
      negamax_value = -negamax(game, depth + 1, -beta, -alpha, -color)
      game.board[space] = nil
      game.current_player = game.current_player == 'X' ? 'O' : 'X'
      p "depth: #{depth}"
      max = [max, negamax_value].max
      @best_score[space] = max if depth == 0
      alpha = [alpha, negamax_value].max
      return alpha if alpha >= beta

    end

    max
  end

  def score_scenarios(depth, game)
    return 0 if game.draw?
    return 1000 / depth if game.winner == 'X'
    return -1000 / depth if depth != 0
    return -1000
  end
end

class GameState
  attr_accessor :current_player, :board


  def initialize(current_player, board)
    self.current_player = current_player
    self.board = board
  end

  def place_marker(space, marker)
    board[space] = marker
  end

  def check_available_spaces
    available = []
    board.each_index do |ndx|
      available << ndx if board[ndx].nil?
    end
    available
  end


  def game_over?
    winner || draw?
  end

  def draw?
    if board.length == 16
      board.compact.size == 16 && winner.nil?
    elsif board.length == 9
      board.compact.size == 9 && winner.nil?
    end
  end

  def winner
    if board.length == 9
      @winner = nil
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
      ].collect {|positions|
        (board[positions[0]] == board[positions[1]] &&
            board[positions[1]] == board[positions[2]] &&
            board[positions[0]]) || nil}.compact.first
    elsif board.length == 16
      @winner = nil
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
      ].collect {|positions|
        (board[positions[0]] == board[positions[1]] &&
            board[positions[1]] == board[positions[2]] &&
            board[positions[2]] == board[positions[3]] &&
            board[positions[0]]) || nil}.compact.first
    end
  end
end

class TicTacToe
  attr_accessor :currentBoard, :difficulty, :gridsize, :finalBoard

  def initialize(difficulty, gridsize)
    @difficulty = difficulty
    @gridsize = gridsize
    setupGame
    @currentBoard = @game_state.board
    @finalBoard = []
  end

  def setupGame
    if @difficulty == "hard" && @gridsize == "4"
      @game_state = GameState.new('X', Array.new(16))
      @ai = PerfectComputer.new
    elsif @difficulty == "easy" && @gridsize == "4"
      @game_state = GameState.new('X', Array.new(16))
    elsif @difficulty == "hard" && @gridsize == "3"
      @ai = PerfectComputer.new
      @game_state = GameState.new('X', Array.new(9))
    elsif @difficulty == "easy" && @gridsize == "3"
      @game_state = GameState.new('X', Array.new(9))
    end
  end

  def ai_move
    move = @ai.choose_space(@game_state)
    @game_state.board[move] = 'X'
    @game_state.winner
  end

  def player_move(string)
    move = string.to_i
    @currentBoard[move] = 'O'
  end

  def available_spaces
    available = []
    @currentBoard.each_index do |ndx|
      available << ndx if @currentBoard[ndx].nil?
    end
    available
  end

  def winner
    if @game_state.game_over?
      if @game_state.winner == "X"
        return "X"
      elsif @game_state.winner
        return "O"

      elsif @game_state.draw?
        return "draw"
      else
        return nil
      end
    end
  end

  def render_board
    @finalBoard = @game_state.board
  end

  def ai_move_easy
    if @difficulty == "easy" && !@game_state.game_over?
      move = available_spaces.sample
      @currentBoard[move] = "X"
    end
  end

  def hard_difficulty_round(string)
    if @difficulty == "hard" && !@game_state.game_over?
      player_move(string)
      if available_spaces.length > 0
        ai_move
        render_board
      end
    end
  end

  def easy_difficulty_round(string)
    if @difficulty == "easy" && !@game_state.game_over?
      player_move(string)
      ai_move_easy
      render_board
    end
  end

  def playGame(string)
    hard_difficulty_round(string)
    easy_difficulty_round(string)
  end
end






