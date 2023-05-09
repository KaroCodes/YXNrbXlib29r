require 'rails_helper'

RSpec.describe SectionPicker, type: :model do
  describe '#call' do

    let(:similarities) { 
        [
            { content: 'Introduction to Graphics Programming', tokens: 4, similarity: 1 },
            { content: 'Ask my book anything', tokens: 4, similarity: 0.8 },
            { content: 'Or ask me!', tokens: 4, similarity: 0.75 },
        ]
    }

    it 'returns most similar sections not exceeding the maximum amount of tokens' do
        sections = SectionPicker.call(similarities, 5)
        expect(sections).to eq("Introduction to Graphics Programming Ask")
    end
   
  end
end