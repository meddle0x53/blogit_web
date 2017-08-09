FROM elixir:1.5

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

RUN npm install

RUN ./build_release.sh

CMD ["bash"]
