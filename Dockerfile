FROM bartoffw/rails5

ADD src /app

VOLUME /app

RUN bundle install