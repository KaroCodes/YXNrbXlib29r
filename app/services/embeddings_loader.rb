require 'rover-df'
require 'numo/narray'

include Numo

class EmbeddingsLoader < ApplicationService

    attr_reader :embeddings_file

    def initialize(embeddings_file)
        @embeddings_file = embeddings_file
    end
  
    # load pre-generated document embeddings from a local file
    def call
        df = Rover.read_csv(embeddings_file)
        df = df[df['embedding'] != nil]
        return df.to_a.map { |data|
            embedding = data['embedding']&.split(',')&.map(&:to_f)
            if embedding
                data['embedding'] = DFloat[*embedding]
            end
            data
        }
    end

end