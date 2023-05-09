class RandomQuestionProvider < ApplicationService

    def call
        id = rand(Question.count) + 1
        match = Question.find(id)
        return {
            question: match[:question],
            answer: match[:answer]
        }
    end

end