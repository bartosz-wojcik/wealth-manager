FROM bartoffw/rails5

ADD src /app

VOLUME /app

RUN bundle install && rails s -b 0.0.0.0