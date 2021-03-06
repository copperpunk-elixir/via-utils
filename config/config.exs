# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
import Config

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.

config :logger, backends: [RingLogger]

config :logger, RingLogger, max_size: 50_000

config :logger,
  level: :debug

config :ring_logger,
  format: "$time $metadata[$level] $levelpad$message\n",
  level: :debug,
  metadata: []
