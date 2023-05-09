require 'numo/narray'

include Numo

SEPARATOR = "\n "
SEPARATOR_TOKENS = 3

class SectionPicker < ApplicationService

    attr_reader :similarities
    attr_reader :max_section_len

    def initialize(similarities, max_section_len)
        @similarities = similarities
        @max_section_len = max_section_len
    end

    # pick most relevant sections of the document based on similarities
    def call
        sections = similarities[0][:content]
        len = similarities[0][:tokens]
        i = 1
        while len < max_section_len && i < similarities.length - 1
            sections += SEPARATOR + similarities[i][:content]
            len += similarities[i][:tokens] + SEPARATOR_TOKENS
            i += 1
        end
        return sections.split(' ')[0..max_section_len - 1].join(' ')
    end

end