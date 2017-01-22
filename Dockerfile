FROM elixir:1.4

MAINTAINER meddle <n.tzvetinov@gmail.com

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y -q install git
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y -q nodejs

ADD . /app
WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get --only-prod

ENV NODE_ENV production
ENV BRUNCH_ENV production
RUN npm install
RUN npm install -g brunch

ENV PORT 4000
ENV MIX_ENV prod
RUN mix compile
RUN brunch build
RUN mix phoenix.digest

CMD ["mix", "phoenix.server"]

EXPOSE 4000
