OPENAI_API_KEY = Rails.application.credentials.openai_api_key
DOC_EMBEDDINGS_FILENAME = 'graphicsbook.embeddings.csv'
DOC_EMBEDDINGS_FILE = "#{Rails.root.to_s}/#{DOC_EMBEDDINGS_FILENAME}"

class QuestionsController < ApplicationController

    def ask
        @answer = AnswerProvider.call(
            params[:question],
            DOC_EMBEDDINGS_FILE,
            OPENAI_API_KEY
        )
        render json: @answer
    end

    def random
        @question = RandomQuestionProvider.call
        render json: @question
    end
end
