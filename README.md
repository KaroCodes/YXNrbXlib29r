# YXNrbXlib29r 🤔

If the name of this app doesn't make any sense try decoding it with base64 🙃

## Tech stack:
* Backend: Ruby 3.2.2, Rails 7
* Frontend: Yarn, JavaScript, React
* Test: RSpec, FactoryBot

## Run

**Generate embeddings**

To generate embeddings for a pdf file run this command in the terminal

    ruby pdf_to_embeddings.rb -f pdf_file

where `pdf_file` can be for example `graphicsbook.pdf`:

    ruby pdf_to_embeddings.rb -f graphicsbook.pdf

**DB**

SQLite (for actual production should use PostgreSQL or something else that deals with concurrent writing better)

To initialize run:

    rake db:migrate



**Server**

Inside the `YXNrbXlib29r` folder:

    bin/dev

Runs on port `3000`

    http://localhost:3000/

## Test

To test all services run:

    rspec spec/services/*

To test individual service (e.g. `SectionPicker`) run:

    rspec spec/services/section_picker_spec.rb

## Deploy
TODO