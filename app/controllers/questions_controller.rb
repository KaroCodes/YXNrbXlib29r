class QuestionsController < ApplicationController
    
    def index
        @questions = Question.all
        render json: @questions
    end

    def show
        @question = Question.find(params[:id])
        render json: @question
    end

    def ask
        @answer = Question.ask(params[:question])
        render json: @answer
    end

    def random
        @question = Question.random()
        render json: @question
    end
end
