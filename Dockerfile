FROM ubuntu:14.04

MAINTAINER meddle <n.tzvetinov@gmail.com

# Set the locale, otherwise elixir will complain later on
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get -y -q install wget
RUN apt-get -y -q install git

# add erlang otp
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
RUN dpkg -i erlang-solutions_1.0_all.deb
RUN apt-get update
RUN apt-get install -y -q imagemagick esl-erlang elixir

ADD . /app
WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get --only-prod

ENV PORT 4000
ENV MIX_ENV prod
RUN mix compile

CMD ["mix", "phoenix.server"]

EXPOSE 4000
