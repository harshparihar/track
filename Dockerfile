ARG BASE_IMAGE

FROM ${BASE_IMAGE}

SHELL ["/bin/bash", "-c"]

LABEL maintainer="Harshvardhan Parihar"

RUN curl https://deb.nodesource.com/setup_12.x | bash
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt update -qq && \
    apt install -y nodejs yarn postgresql-client

WORKDIR /myapp

COPY Gemfile Gemfile.lock /myapp/

RUN bundle install

RUN useradd -u 1000 hparihar

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]