require 'numo/narray'

include Numo

EMBEDDINGS_MODEL = 'text-embedding-ada-002'

class QueryEmbeddingGenerator < ApplicationService

    attr_reader :query
    attr_reader :openAi

    def initialize(query, openAi)
        @query = query
        @openAi = openAi
    end

    # generate embedding vector for a given query
    def call
        res = openAi.embeddings(
            parameters: {
                model: EMBEDDINGS_MODEL,
                input: query
            }
        )
        begin
            query_embedding = res['data'][0]['embedding']
            if !query_embedding
                return nil
            end
            return DFloat[*query_embedding]
        rescue
            return nil
        end
    end

end