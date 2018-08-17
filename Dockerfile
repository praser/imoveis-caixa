
FROM ruby:2.4.2
LABEL Name=imoveis-caixa Version=0.0.1
RUN apt-get update
RUN apt-get install p7zip-full --yes
RUN bundle config --global frozen 1
WORKDIR /app
COPY . /app
COPY Gemfile Gemfile.lock ./
RUN bundle install
CMD ["ruby", "script.rb"]