import gleeunit/should
import node_pg
import test_helpers

// ============================================================================
// FFI Test Helpers for Error Scenario Mocks
// ============================================================================

@external(javascript, "./ffi.mjs", "testCreateConnectionError")
fn test_create_connection_error(message: String) -> node_pg.DatabaseError

@external(javascript, "./ffi.mjs", "testCreateSyntaxError")
fn test_create_syntax_error() -> node_pg.DatabaseError

@external(javascript, "./ffi.mjs", "testCreateAuthenticationError")
fn test_create_authentication_error() -> node_pg.DatabaseError

@external(javascript, "./ffi.mjs", "testCreateTableNotFoundError")
fn test_create_table_not_found_error() -> node_pg.DatabaseError

@external(javascript, "./ffi.mjs", "testCreateUniqueViolationError")
fn test_create_unique_violation_error() -> node_pg.DatabaseError

@external(javascript, "./ffi.mjs", "testMockQueryFailure")
fn test_mock_query_failure(
  error_code: String,
) -> Result(node_pg.QueryResult, node_pg.DatabaseError)

// ============================================================================
// Error Handling Tests
// ============================================================================

// Test: Connection error
pub fn connection_error_test() {
  let error = test_create_connection_error("Connection timeout")

  error.message
  |> should.equal("Connection timeout")

  test_helpers.assert_error_code(error, "ECONNREFUSED")
  test_helpers.assert_has_detail(error)
}

// Test: Authentication error (PostgreSQL code: 28P01)
pub fn authentication_error_test() {
  let error = test_create_authentication_error()

  test_helpers.assert_error_code(error, "28P01")
  test_helpers.assert_has_message(error)
}

// Test: SQL syntax error (PostgreSQL code: 42601)
pub fn syntax_error_test() {
  let error = test_create_syntax_error()

  test_helpers.assert_error_code(error, "42601")
  test_helpers.assert_has_message(error)
}

// Test: Table not found error (PostgreSQL code: 42P01)
pub fn table_not_found_error_test() {
  let error = test_create_table_not_found_error()

  test_helpers.assert_error_code(error, "42P01")
  test_helpers.assert_has_message(error)
}

// Test: Unique constraint violation error (PostgreSQL code: 23505)
pub fn unique_violation_error_test() {
  let error = test_create_unique_violation_error()

  test_helpers.assert_error_code(error, "23505")
  test_helpers.assert_has_detail(error)
}

// Test: Error code preservation through Result type
pub fn error_code_preservation_test() {
  let result = test_mock_query_failure("42601")
  let db_error = test_helpers.assert_error(result)

  test_helpers.assert_error_code(db_error, "42601")
}

// Test: Error detail and hint extraction
pub fn error_detail_extraction_test() {
  let error = test_create_unique_violation_error()

  test_helpers.assert_has_detail(error)
  test_helpers.assert_has_hint(error)
}
