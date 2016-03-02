class GameController < ApplicationController
  def play_magic8
    # added answer to array
    answer_array = ["Yup!","Fuhgeddaboudit", "Maybe", "Ask: what would your mother do?", "Ask: what would an Australian do, then do the opposite", "Your answer here"]
    
    # if question submitted thru form and it is not empty. generate random number to get the randon answer
    if params.has_key?(:question) && !params[:question].strip.empty? 
      num = Random.new
      a = num.rand(answer_array.length)
      flash.now[:alert] = answer_array[a]
    end
  end
end
