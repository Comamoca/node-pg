import gleam/dynamic.{type Dynamic}
import gleam/option.{None, Some}
import gleeunit/should
import node_pg

// ============================================================================
// FFI Test Helper Declarations
// ============================================================================

/// Test helper: Verify Option(String) extraction
@external(javascript, "./ffi.mjs", "testExtractOptionString")
fn test_extract_option_string(
  option: option.Option(String),
  expected: String,
) -> Bool

/// Test helper: Verify Option is None
@external(javascript, "./ffi.mjs", "testIsNone")
fn test_is_none(option: option.Option(a)) -> Bool

/// Test helper: Create Some(42)
@external(javascript, "./ffi.mjs", "testCreateSome42")
fn test_create_some_42() -> option.Option(Int)

/// Test helper: Verify Option(Int) equals value
@external(javascript, "./ffi.mjs", "testOptionIntEquals")
fn test_option_int_equals(option: option.Option(Int), expected: Int) -> Bool

/// Test helper: Create Gleam None from JS side
@external(javascript, "./ffi.mjs", "testCreateNone")
fn create_none() -> option.Option(Dynamic)

/// Test helper: Convert Config to JS object and return it as Dynamic
@external(javascript, "./ffi.mjs", "testConfigToJS")
fn config_to_js(config: node_pg.Config) -> Dynamic

/// Test helper: Create DatabaseError from error components
@external(javascript, "./ffi.mjs", "testCreateDatabaseError")
fn create_database_error(
  message: String,
  has_code: Bool,
  has_detail: Bool,
  has_hint: Bool,
) -> node_pg.DatabaseError

/// Test helper: Create QueryResult from mock data
@external(javascript, "./ffi.mjs", "testCreateQueryResult")
fn create_query_result(num_rows: Int, command: String) -> node_pg.QueryResult

// ============================================================================
// Option Type Conversion Tests
// ============================================================================

// Test: JavaScript can extract value from Gleam Some
pub fn option_some_extraction_test() {
  let gleam_some = Some("test_value")

  // JavaScript should correctly extract "test_value"
  test_extract_option_string(gleam_some, "test_value")
  |> should.equal(True)
}

// Test: JavaScript can detect Gleam None
pub fn option_none_extraction_test() {
  let gleam_none = None

  // JavaScript should detect this is None
  test_is_none(gleam_none)
  |> should.equal(True)
}

// Test: JavaScript can create Gleam Some
pub fn option_some_creation_test() {
  let gleam_option = test_create_some_42()

  // Should be Some(42)
  test_option_int_equals(gleam_option, 42)
  |> should.equal(True)
}

// Test: JavaScript can create Gleam None
pub fn option_none_creation_test() {
  let gleam_option = create_none()

  // Should be detected as None
  test_is_none(gleam_option)
  |> should.equal(True)
}

// ============================================================================
// Config Type Conversion Tests
// ============================================================================

// Test: Config with Some values converts correctly
pub fn config_some_values_conversion_test() {
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

  // Convert to JS and verify it doesn't panic
  let _js_config = config_to_js(config)

  // If we get here, conversion succeeded
  True
  |> should.equal(True)
}

// Test: Config with all None values converts correctly
pub fn config_none_values_conversion_test() {
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

  // Convert to JS and verify it doesn't panic
  let _js_config = config_to_js(config)

  // If we get here, conversion succeeded
  True
  |> should.equal(True)
}

// ============================================================================
// DatabaseError Type Conversion Tests
// ============================================================================

// Test: DatabaseError with all fields populated
pub fn database_error_full_test() {
  let error = create_database_error("Connection failed", True, True, True)

  error.message
  |> should.equal("Connection failed")

  error.code
  |> should.equal(Some("28P01"))

  error.detail
  |> should.equal(Some("Password authentication failed"))

  error.hint
  |> should.equal(Some("Check your credentials"))
}

// Test: DatabaseError with minimal fields
pub fn database_error_minimal_test() {
  let error = create_database_error("Unknown error", False, False, False)

  error.message
  |> should.equal("Unknown error")

  error.code
  |> should.equal(None)

  error.detail
  |> should.equal(None)

  error.hint
  |> should.equal(None)
}

// ============================================================================
// QueryResult Type Conversion Tests
// ============================================================================

// Test: QueryResult with rows
pub fn query_result_with_rows_test() {
  let result = create_query_result(2, "SELECT")

  result.command
  |> should.equal("SELECT")

  result.row_count
  |> should.equal(Some(2))

  // Verify rows list has correct length
  case result.rows {
    [_first, _second] -> True |> should.equal(True)
    _ -> panic as "Expected 2 rows"
  }
}

// Test: QueryResult with zero rows
pub fn query_result_empty_test() {
  let result = create_query_result(0, "SELECT")

  result.command
  |> should.equal("SELECT")

  result.row_count
  |> should.equal(Some(0))

  result.rows
  |> should.equal([])
}

// Test: QueryResult fields are populated
pub fn query_result_fields_test() {
  let result = create_query_result(0, "SELECT")

  // Fields should be Some with our mock field info
  case result.fields {
    Some(fields) -> {
      // Should have 2 fields (id, name) from our mock
      case fields {
        [first, second] -> {
          first.name
          |> should.equal("id")

          second.name
          |> should.equal("name")
        }
        _ -> panic as "Expected 2 fields"
      }
    }
    None -> panic as "Expected Some(fields)"
  }
}
