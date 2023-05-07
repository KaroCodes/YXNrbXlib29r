require 'openai'
require 'rover-df'
require 'numo/narray'

include OpenAI
include Numo

OPENAI_API_KEY = Rails.application.credentials.openai_api_key

EMBEDDINGS_MODEL = 'text-embedding-ada-002'
COMPLETION_MODEL = 'text-davinci-001'

DOC_EMBEDDINGS_FILE = 'graphicsbook.embeddings.csv'

MAX_SECTION_LEN = 500
SEPARATOR = "\n "
SEPARATOR_TOKENS = 3

MAX_COMPLETION_LEN = 80
COMPLETION_TEMPERATURE = 0.0

class Question < ApplicationRecord

    def self.ask(question)

        if !question.end_with?('?')
            question = "#{question}?"
        end

        answer = Question.where(question: question).first()

        if answer
            return answer
        end

        # load existing embeddings from file
        root = Rails.root.to_s
        embeddings_file = "#{root}/#{DOC_EMBEDDINGS_FILE}"
        doc_embeddings = load_doc_embeddings(embeddings_file)

        # generate embedding for question
        openAi = OpenAI::Client.new(access_token: OPENAI_API_KEY)
        query_vec = generate_embedding_for_query(openAi, question)

        # pick content most relevant to the query
        similarities = calc_similiarities(doc_embeddings, query_vec)
        sections = pick_most_relevant_sections(similarities)
            
        # generate a prompt for Completion
        answer = generate_answer(openAi, question, sections)

        # insert the answered question into the db
        answeredQuestion = Question.create(
            question: question,
            answer: answer
        )

        return answeredQuestion
    end

    private

        # use OpenAI Completion endpoint to summarize the knowledge from the book
        def self.generate_answer(openAi, question, sections)
            header = "Introduction to Computer Graphics is a book written by David J. Eck. Please keep your answers to three sentences maximum, and speak in complete sentences.\n\nContext that may be useful, pulled from the Introduction to Computer Graphics:\n"
            footer = "\n\nQuestion: #{question} \n\nAnswer: "
            prompt = header + sections + footer
            puts prompt
            res = openAi.completions(
                parameters: {
                    model: COMPLETION_MODEL,
                    temperature: COMPLETION_TEMPERATURE,
                    prompt: prompt,
                    max_tokens: MAX_COMPLETION_LEN
                })
            return res['choices'].map { |c| c['text'] }.join(' ').strip
        end

        # generate embedding vector for a given query
        def self.generate_embedding_for_query(openAi, query)
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

        # pick most relevant sections of the document based on similarities
        def self.pick_most_relevant_sections(similarities)
            sections = similarities[0][:content]
            len = similarities[0][:tokens]
            i = 1
            while len < MAX_SECTION_LEN && i < similarities.length - 1
                sections += SEPARATOR + similarities[i][:content]
                len += similarities[i][:tokens] + SEPARATOR_TOKENS
                i += 1
            end
            return sections.split(' ')[0..MAX_SECTION_LEN - 1].join(' ')
        end

        # calculate similarities between given query and the document embeddings
        def self.calc_similiarities(doc_embeddings, query_vec)
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
        
        # load pre-generated document embeddings from a local file
        def self.load_doc_embeddings(embeddings_file)
            df = Rover.read_csv(embeddings_file)
            df = df[df['embedding'] != nil]
            return df.to_a.map { |data|
                data['embedding'] = vectorize_embedding(data['embedding']&.to_s)
                data
            }
        end

        def self.vectorize_embedding(embedding_s)
            if !embedding_s
                return nil
            end
            embedding = embedding_s.split(',').map(&:to_f)
            return DFloat[*embedding]
        end

end
