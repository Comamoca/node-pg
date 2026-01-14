import gleam/option.{None, Some}
import gleeunit/should
import node_pg

// Test: Config type can be created with all None values
pub fn config_empty_test() {
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

  // Just verify it compiles and creates successfully
  config.user
  |> should.equal(None)
}

// Test: Config with basic connection parameters
pub fn config_basic_params_test() {
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
      application_name: Some("test_app"),
      connection_timeout_millis: None,
      keep_alive_initial_delay_millis: None,
      idle_in_transaction_session_timeout: None,
      client_encoding: None,
      fallback_application_name: None,
      options: None,
    )

  config.user
  |> should.equal(Some("testuser"))

  config.database
  |> should.equal(Some("testdb"))

  config.port
  |> should.equal(Some(5432))
}

// Test: Config with connection string
pub fn config_connection_string_test() {
  let config =
    node_pg.Config(
      user: None,
      password: None,
      host: None,
      port: None,
      database: None,
      connection_string: Some("postgresql://user:pass@localhost:5432/mydb"),
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

  config.connection_string
  |> should.equal(Some("postgresql://user:pass@localhost:5432/mydb"))
}

// Test: DatabaseError type creation
pub fn database_error_test() {
  let error =
    node_pg.DatabaseError(
      message: "Connection failed",
      code: Some("28P01"),
      detail: Some("Password authentication failed"),
      hint: Some("Check your credentials"),
    )

  error.message
  |> should.equal("Connection failed")

  error.code
  |> should.equal(Some("28P01"))
}

// Test: QueryResult type creation
pub fn query_result_test() {
  let result =
    node_pg.QueryResult(
      rows: [],
      row_count: Some(0),
      command: "SELECT",
      fields: None,
    )

  result.command
  |> should.equal("SELECT")

  result.row_count
  |> should.equal(Some(0))
}

// Test: FieldInfo type creation
pub fn field_info_test() {
  let field =
    node_pg.FieldInfo(
      name: "id",
      table_id: 16_384,
      column_id: 1,
      data_type_id: 23,
    )

  field.name
  |> should.equal("id")

  field.table_id
  |> should.equal(16_384)
}
