require 'rails_helper'

RSpec.describe EmbeddingsLoader, type: :model do
  describe '#call' do

    let(:csv) {
        Tempfile.new('csv').tap do |f|
            f << ['title', 'content', 'tokens', 'embedding'].join(',') + "\r"
            f << ['Page 1', 'Introduction to Graphics Programming', 4, "\"0.8,1.2,-1.3\""].join(',') + "\r"
            f << ['Page 2', 'Version 1.3', 2, ""].join(',') + "\r"
            f.close
        end
    }

    it 'returns all non-null embeddings present in the file' do
        embeddings = EmbeddingsLoader.call(csv)
        expect(embeddings.length).to eq(1)
        expect(embeddings[0]['title']).to eq('Page 1')
    end
   
  end
end