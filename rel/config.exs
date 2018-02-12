# Import all plugins from `rel/plugins`
# They can then be used by adding `plugin MyPlugin` to
# either an environment, or release definition, where
# `MyPlugin` is the name of the plugin module.
Path.join(["rel", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    default_release: :default,
    default_environment: :prod

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html


# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"RQ8zMUO*qm$AhrS*mbS}uHRoI8RAD8o;)x]t.z~(0NxSfEYynnqrw2Hh1B)I@JMo"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"ae3%2]M:MPC4TK]o]Lj{tfffBtV/{Cvre?9_FFY96.=|z]9mv:H`E{0m{TLl,HC]"
end

release :blogit_web do
  set version: current_version(:blogit_web)
end
