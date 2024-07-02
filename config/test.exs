import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :web_cart, WebCartWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "RJleTJGmO2Ss8Cb0LVSHxsKXHNU/912UqsQ612/Ohqp2sfVA9UU+2OJ+/BRpi29+",
  server: false

# In test we don't send emails.
config :web_cart, WebCart.Mailer,
  adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
