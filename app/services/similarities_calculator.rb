require 'numo/narray'

include Numo

class SimilaritiesCalculator < ApplicationService

    attr_reader :query_vec
    attr_reader :doc_embeddings

    def initialize(query_vec, doc_embeddings)
        @query_vec = query_vec
        @doc_embeddings = doc_embeddings
    end

    # calculate similarities between given query and the document embeddings
    def call
        return doc_embeddings
            .map { |doc_embedding|
                doc_vec = doc_embedding['embedding']
                similarity = doc_vec.dot query_vec
                {
                    content: doc_embedding['content'],
                    tokens: doc_embedding['tokens'],
                    similarity: similarity
                }
            }
            .sort_by { |s| s[:similarity] }
            .reverse()
    end

end