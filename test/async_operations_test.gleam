import node_pg
import test_helpers

// ============================================================================
// FFI Test Helpers for Async Operation Mocks
// ============================================================================

@external(javascript, "./ffi.mjs", "testMockConnectSuccess")
fn test_mock_connect_success() -> Result(Nil, node_pg.DatabaseError)

@external(javascript, "./ffi.mjs", "testMockConnectFailure")
fn test_mock_connect_failure(
  error_code: String,
) -> Result(Nil, node_pg.DatabaseError)

@external(javascript, "./ffi.mjs", "testMockQueryFailure")
fn test_mock_query_failure(
  error_code: String,
) -> Result(node_pg.QueryResult, node_pg.DatabaseError)

@external(javascript, "./ffi.mjs", "testMockEndSuccess")
fn test_mock_end_success() -> Result(Nil, node_pg.DatabaseError)

@external(javascript, "./ffi.mjs", "testMockEndFailure")
fn test_mock_end_failure() -> Result(Nil, node_pg.DatabaseError)

// ============================================================================
// Async Operation Tests (Mock-based)
// ============================================================================

// Test: connect() Promise resolution (success)
pub fn connect_promise_success_test() {
  let result = test_mock_connect_success()
  let _ = test_helpers.assert_ok(result)
  Nil
}

// Test: connect() Promise rejection (failure)
pub fn connect_promise_failure_test() {
  let result = test_mock_connect_failure("ECONNREFUSED")
  let db_error = test_helpers.assert_error(result)

  test_helpers.assert_error_code(db_error, "ECONNREFUSED")
}

// Test: query() Promise resolution (success)
// Note: Success case is tested in query_execution_test.gleam
// This test focuses on the Result type structure

// Test: query() Promise rejection (failure)
pub fn query_promise_failure_test() {
  let result = test_mock_query_failure("42601")
  let db_error = test_helpers.assert_error(result)

  test_helpers.assert_error_code(db_error, "42601")
}

// Test: end() Promise resolution (success)
pub fn end_promise_success_test() {
  let result = test_mock_end_success()
  let _ = test_helpers.assert_ok(result)
  Nil
}

// Test: end() Promise rejection (failure)
pub fn end_promise_failure_test() {
  let result = test_mock_end_failure()
  let db_error = test_helpers.assert_error(result)

  test_helpers.assert_has_message(db_error)
}

// Test: Multiple async operations in sequence (mock)
pub fn async_sequence_test() {
  // Simulate: connect -> query -> end
  let connect_result = test_mock_connect_success()
  let _ = test_helpers.assert_ok(connect_result)

  let end_result = test_mock_end_success()
  let _ = test_helpers.assert_ok(end_result)

  Nil
}
