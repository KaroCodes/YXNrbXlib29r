COMPLETION_MODEL = 'text-davinci-001'
MAX_COMPLETION_LEN = 80
COMPLETION_TEMPERATURE = 0.0

class CompletionGenerator < ApplicationService

    attr_reader :question
    attr_reader :sections
    attr_reader :openAi

    def initialize(question, sections, openAi)
        @question = question
        @sections = sections
        @openAi = openAi
    end

    def call
        header = "Introduction to Computer Graphics is a book written by David J. Eck. Please keep your answers to three sentences maximum, and speak in complete sentences.\n\nContext that may be useful, pulled from the Introduction to Computer Graphics:\n"
        footer = "\n\nQuestion: #{question} \n\nAnswer: "
        prompt = header + sections + footer

        res = openAi.completions(
            parameters: {
                model: COMPLETION_MODEL,
                temperature: COMPLETION_TEMPERATURE,
                prompt: prompt,
                max_tokens: MAX_COMPLETION_LEN
            })
        return res['choices'].map { |c| c['text'] }.join(' ').strip
    end

end