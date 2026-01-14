import gleam/option.{None, Some}
import gleeunit/should
import node_pg

// Test: new_client creates a Client instance from Config
pub fn new_client_creates_instance_test() {
  let config =
    node_pg.Config(
      user: Some("testuser"),
      password: Some("testpass"),
      host: Some("localhost"),
      port: Some(5432),
      database: Some("testdb"),
      connection_string: None,
      ssl: None,
      types: None,
      statement_timeout: None,
      query_timeout: None,
      lock_timeout: None,
      application_name: None,
      connection_timeout_millis: None,
      keep_alive_initial_delay_millis: None,
      idle_in_transaction_session_timeout: None,
      client_encoding: None,
      fallback_application_name: None,
      options: None,
    )

  // Should create a client without error
  let _client = node_pg.new_client(config)

  // If we get here, the client was created successfully
  True
  |> should.equal(True)
}

// Test: new_client with empty config
pub fn new_client_empty_config_test() {
  let config =
    node_pg.Config(
      user: None,
      password: None,
      host: None,
      port: None,
      database: None,
      connection_string: None,
      ssl: None,
      types: None,
      statement_timeout: None,
      query_timeout: None,
      lock_timeout: None,
      application_name: None,
      connection_timeout_millis: None,
      keep_alive_initial_delay_millis: None,
      idle_in_transaction_session_timeout: None,
      client_encoding: None,
      fallback_application_name: None,
      options: None,
    )

  // Should create a client with default values from environment
  let _client = node_pg.new_client(config)

  True
  |> should.equal(True)
}

// Test: new_client with connection string
pub fn new_client_connection_string_test() {
  let config =
    node_pg.Config(
      user: None,
      password: None,
      host: None,
      port: None,
      database: None,
      connection_string: Some(
        "postgresql://testuser:testpass@localhost:5432/testdb",
      ),
      ssl: None,
      types: None,
      statement_timeout: None,
      query_timeout: None,
      lock_timeout: None,
      application_name: None,
      connection_timeout_millis: None,
      keep_alive_initial_delay_millis: None,
      idle_in_transaction_session_timeout: None,
      client_encoding: None,
      fallback_application_name: None,
      options: None,
    )

  let _client = node_pg.new_client(config)

  True
  |> should.equal(True)
}

// Test: empty_config helper function
pub fn empty_config_helper_test() {
  let config = node_pg.empty_config()

  // Verify all fields are None
  config.user
  |> should.equal(None)

  config.host
  |> should.equal(None)

  config.database
  |> should.equal(None)

  config.connection_string
  |> should.equal(None)

  // Should be able to create a client with empty config
  let _client = node_pg.new_client(config)

  True
  |> should.equal(True)
}

// Test: connection_string_config helper function
pub fn connection_string_config_helper_test() {
  let conn_str = "postgresql://testuser:testpass@localhost:5432/testdb"
  let config = node_pg.connection_string_config(conn_str)

  // Verify connection string is set
  config.connection_string
  |> should.equal(Some(conn_str))

  // Verify other fields are None
  config.user
  |> should.equal(None)

  config.host
  |> should.equal(None)

  config.database
  |> should.equal(None)

  // Should be able to create a client
  let _client = node_pg.new_client(config)

  True
  |> should.equal(True)
}

// Test: create_config helper function
pub fn create_config_helper_test() {
  let config =
    node_pg.create_config(
      Some("testuser"),
      Some("testpass"),
      Some("localhost"),
      Some(5432),
      Some("testdb"),
    )

  // Verify basic fields are set
  config.user
  |> should.equal(Some("testuser"))

  config.password
  |> should.equal(Some("testpass"))

  config.host
  |> should.equal(Some("localhost"))

  config.port
  |> should.equal(Some(5432))

  config.database
  |> should.equal(Some("testdb"))

  // Verify other fields are None
  config.connection_string
  |> should.equal(None)

  config.application_name
  |> should.equal(None)
}
