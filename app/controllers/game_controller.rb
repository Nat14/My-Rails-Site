class GameController < ApplicationController

  def play_games
    ### magic 8 game
    # added answer to array
    answer_array = ["Yup!","Fuhgeddaboudit", "Maybe", "Ask: what would your mother do?", "Ask: what would an Australian do, then do the opposite", "Your answer here"]

    # if question submitted thru form and it is not empty. generate random number to get the randon answer
    if params.has_key?(:q1) && !params[:q1].strip.empty?
      num = Random.new
      a = num.rand(answer_array.length)
      flash.now[:message] = answer_array[a]
      @question = params[:q1]+"?" if params[:q1][-1] != "?"
    end
  end

  def play_hilo
    ### hilo game
    if cookies[:secret_number].nil?
        cookies[:secret_number] = Random.rand(100)
        cookies[:all_guess] = " "
    end

    @secret_number = cookies[:secret_number].to_i
    @guess = params[:guess].to_i

    if @guess < 100 && @guess > 0
      cookies[:all_guess] = cookies[:all_guess] + @guess.to_s + ", "
      if @secret_number == @guess
        flash.now[:notice] = "You win! #{@guess} is correct number. Guess another number to play again!"
        cookies[:secret_number] = Random.rand(100)
        cookies[:all_guess] = " "
      elsif @secret_number > @guess
        flash.now[:alert] = "Too Low, guess again!"
      elsif @secret_number < @guess
        flash.now[:alert] = "Too High, guess again!"
      end
    else
      flash.now[:alert] = "Please enter a NUMBER between 1 and 100!"
    end
    redirect_to '/game/play_games#set-2'
  end

end
