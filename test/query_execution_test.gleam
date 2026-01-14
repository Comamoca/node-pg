import gleeunit/should
import node_pg
import test_helpers

// ============================================================================
// FFI Test Helpers for Query Execution Mocks
// ============================================================================

@external(javascript, "./ffi.mjs", "testMockQuerySuccess")
fn test_mock_query_success(
  row_count: Int,
  command: String,
) -> Result(node_pg.QueryResult, node_pg.DatabaseError)

@external(javascript, "./ffi.mjs", "testMockEmptyResultSet")
fn test_mock_empty_result_set() -> Result(
  node_pg.QueryResult,
  node_pg.DatabaseError,
)

@external(javascript, "./ffi.mjs", "testMockQueryParameterValidation")
fn test_mock_query_parameter_validation(params: List(a)) -> Bool

// ============================================================================
// Query Execution Tests
// ============================================================================

// Test: Successful SELECT query with multiple rows
pub fn query_select_success_test() {
  let result = test_mock_query_success(5, "SELECT")
  let query_result = test_helpers.assert_ok(result)

  test_helpers.assert_command(query_result, "SELECT")
  test_helpers.assert_row_count(query_result, 5)
}

// Test: Successful SELECT query with single row
pub fn query_select_single_row_test() {
  let result = test_mock_query_success(1, "SELECT")
  let query_result = test_helpers.assert_ok(result)

  test_helpers.assert_command(query_result, "SELECT")
  test_helpers.assert_row_count(query_result, 1)
}

// Test: Parameterized query parameter validation
pub fn query_parameterized_test() {
  let params = ["value1", "value2", "value3"]

  let is_valid = test_mock_query_parameter_validation(params)

  is_valid
  |> should.equal(True)
}

// Test: Empty result set (0 rows)
pub fn query_empty_result_test() {
  let result = test_mock_empty_result_set()
  let query_result = test_helpers.assert_ok(result)

  test_helpers.assert_command(query_result, "SELECT")
  test_helpers.assert_row_count(query_result, 0)
}

// Test: Field metadata extraction
pub fn query_field_metadata_test() {
  let result = test_mock_query_success(3, "SELECT")
  let query_result = test_helpers.assert_ok(result)

  test_helpers.assert_has_fields(query_result)
}

// Test: Row count validation for various counts
pub fn query_row_count_validation_test() {
  // Test 0 rows
  let result_0 = test_mock_query_success(0, "SELECT")
  test_helpers.assert_row_count(test_helpers.assert_ok(result_0), 0)

  // Test 10 rows
  let result_10 = test_mock_query_success(10, "SELECT")
  test_helpers.assert_row_count(test_helpers.assert_ok(result_10), 10)

  // Test 100 rows
  let result_100 = test_mock_query_success(100, "SELECT")
  test_helpers.assert_row_count(test_helpers.assert_ok(result_100), 100)
}
