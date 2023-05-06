require 'rubygems'
require 'optparse'
require 'ostruct'
require 'pdf/reader'
require 'tokenizers'
require 'rover-df'
require 'numo/narray'
require "openai"

include OpenAI
include Rover
include Numo

TOKENIZER_MODEL = 'gpt2'

OPENAI_API_KEY = ENV['OPENAI_API_KEY']

EMBEDDINGS_MODEL = 'text-embedding-ada-002'

# Retrieves embedding for a given text using provided OpenAI model
# and embeddings model name
def get_embedding(metapage, openAi, embeddingsModel)
    title = metapage[:title]
    puts 'Processing %s...' % title
    content = metapage[:content]
    res = openAi.embeddings(
        parameters: {
            model: embeddingsModel,
            input: content
        }
    )
    begin
        embedding = (res['data'][0]['embedding'])&.join(',')
        puts embedding
        puts '%s done.' % title
        return embedding
    rescue
        puts '%s failed.' % title
        return nil
    end
end

# Generates and attaches embeddings to metapages (pages with metadata)
def attach_embeddings(metapages, openAi, embeddingsModel)
    metapages.each { |metapage| 
        embedding = get_embedding(metapage, openAi, embeddingsModel)
        metapage['embedding'] = embedding
    }
end

def write_file(filename, content)
    File.open(filename, 'w') { |file| file.write(content) }
end

# Saves data to a csv file
def save_as_csv(filename, data)
    df = DataFrame.new(data)
    write_file(filename, df.to_csv)
end

# Extract page content, title and token count
def extract_metapages(pages, tokenizer)
    return pages.map.with_index { |page, idx|
        content = page.text.split().join(' ')
        title = 'Page %d' % (idx + 1)
        tokens = tokenizer.encode(content).tokens.length()
        { title: title, content: content, tokens: tokens }
    }
end

# Converts pdf to per-page embeddings and saves it into a CSV file
def pdf_to_embeddings(pdf_file)
    puts 'Processing embeddings for %s' % pdf_file

    reader = PDF::Reader.new(pdf_file)
    last_page = reader.page_count
    pages = (1..last_page).to_a.map { |i| reader.page(i) }

    tokenizer = Tokenizers.from_pretrained(TOKENIZER_MODEL)
    metapages = extract_metapages(pages, tokenizer)

    openAi = OpenAI::Client.new(access_token: OPENAI_API_KEY)
    attach_embeddings(metapages, openAi, EMBEDDINGS_MODEL)

    filename = '%s.embeddings.csv' %  File.basename(pdf_file, '.pdf') 
    save_as_csv(filename, metapages)

    puts 'Embeddings saved to %s' % filename
end


options = OpenStruct.new
OptionParser.new do |opt|
  opt.on('-f', '--file FILE', 'The PDF file to generate embeddings for') { |o| options.file = o }
end.parse!

pdf_to_embeddings(options.file)
