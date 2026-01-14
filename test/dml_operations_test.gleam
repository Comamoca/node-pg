import node_pg
import test_helpers

// ============================================================================
// FFI Test Helpers for DML Operation Mocks
// ============================================================================

@external(javascript, "./ffi.mjs", "testCreateInsertResult")
fn test_create_insert_result(row_count: Int) -> node_pg.QueryResult

@external(javascript, "./ffi.mjs", "testCreateUpdateResult")
fn test_create_update_result(row_count: Int) -> node_pg.QueryResult

@external(javascript, "./ffi.mjs", "testCreateDeleteResult")
fn test_create_delete_result(row_count: Int) -> node_pg.QueryResult

@external(javascript, "./ffi.mjs", "testCreateCreateTableResult")
fn test_create_create_table_result() -> node_pg.QueryResult

@external(javascript, "./ffi.mjs", "testCreateDropTableResult")
fn test_create_drop_table_result() -> node_pg.QueryResult

// ============================================================================
// DML Operation Tests
// ============================================================================

// Test: INSERT operation with row count validation
pub fn insert_operation_test() {
  let result = test_create_insert_result(3)

  test_helpers.assert_command(result, "INSERT")
  test_helpers.assert_row_count(result, 3)
}

// Test: UPDATE operation with affected row count
pub fn update_operation_test() {
  let result = test_create_update_result(5)

  test_helpers.assert_command(result, "UPDATE")
  test_helpers.assert_row_count(result, 5)
}

// Test: DELETE operation with deleted row count
pub fn delete_operation_test() {
  let result = test_create_delete_result(2)

  test_helpers.assert_command(result, "DELETE")
  test_helpers.assert_row_count(result, 2)
}

// Test: CREATE TABLE operation
pub fn create_table_test() {
  let result = test_create_create_table_result()

  test_helpers.assert_command(result, "CREATE")
}

// Test: DROP TABLE operation
pub fn drop_table_test() {
  let result = test_create_drop_table_result()

  test_helpers.assert_command(result, "DROP")
}

// Test: DML with zero affected rows
pub fn dml_row_count_zero_test() {
  // UPDATE that matches no rows
  let update_result = test_create_update_result(0)
  test_helpers.assert_command(update_result, "UPDATE")
  test_helpers.assert_row_count(update_result, 0)

  // DELETE that matches no rows
  let delete_result = test_create_delete_result(0)
  test_helpers.assert_command(delete_result, "DELETE")
  test_helpers.assert_row_count(delete_result, 0)
}
