#!/bin/bash
export MIX_ENV=prod

mix deps.get

./node_modules/brunch/bin/brunch b -p
mix phoenix.digest
mix release --env=prod $1
