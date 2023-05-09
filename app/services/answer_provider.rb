require 'openai'

class AnswerProvider < ApplicationService

    attr_reader :question
    attr_reader :doc_embeddings_file
    attr_reader :openai_api_key

    def initialize(question, doc_embeddings_file, openai_api_key)
        @question = question
        @doc_embeddings_file = doc_embeddings_file
        @openai_api_key = openai_api_key
    end

    def call
        if !question.end_with?('?')
            @question = "#{question}?"
        end

        match = Question.where(question: question).first()

        if match
            return { answer: match[:answer] }
        end

        # load existing embeddings from file
        doc_embeddings = EmbeddingsLoader.call(doc_embeddings_file)

        # generate embedding for question
        openAi = OpenAI::Client.new(access_token: openai_api_key)
        query_vec = QueryEmbeddingGenerator.call(question, openAi)

        # pick content most relevant to the query
        similarities = SimilaritiesCalculator.call(query_vec, doc_embeddings)
        sections = SectionPicker.call(similarities, MAX_SECTION_LEN)
            
        # generate a prompt for Completion
        answer = CompletionGenerator.call(question, sections, openAi)

        # insert the answered question into the db
        answeredQuestion = Question.create(
            question: question,
            answer: answer
        )

        return { answer: answer }
    end

end