FROM lokalebasen/elixir
MAINTAINER Martin Neiiendam mn@lokalebasen.dk
ENV REFRESHED_AT 2015-01-08

ENV MIX_ENV prod

WORKDIR /var/www/app

ADD build.tar /var/www/app/

RUN yes | mix deps.get
RUN mix deps.compile
RUN mix compile.protocols
RUN mix release

CMD ["rel/lb_searchex/bin/lb_searchex", "foreground"]
