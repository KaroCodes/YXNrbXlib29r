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
        @question = Question.ask(params[:question])
        render json: @question
    end

    def create
        @question = Question.create(
            question: params[:question],
            answer: params[:answer]
        )
        render json: @question
    end

end
