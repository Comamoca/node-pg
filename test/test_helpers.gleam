/// Test helper utilities for node_pg tests
/// Provides common assertion patterns to reduce code duplication
import gleam/option.{type Option, None, Some}
import gleeunit/should
import node_pg

// ============================================================================
// Result Assertion Helpers
// ============================================================================

/// Assert that a Result is Ok and return the unwrapped value
pub fn assert_ok(result: Result(a, b)) -> a {
  case result {
    Ok(value) -> value
    Error(_) -> panic as "Expected Ok result, got Error"
  }
}

/// Assert that a Result is Error and return the unwrapped error
pub fn assert_error(result: Result(a, b)) -> b {
  case result {
    Ok(_) -> panic as "Expected Error result, got Ok"
    Error(error) -> error
  }
}

// ============================================================================
// Option Assertion Helpers
// ============================================================================

/// Assert that an Option is Some and return the unwrapped value
pub fn assert_some(option: Option(a)) -> a {
  case option {
    Some(value) -> value
    None -> panic as "Expected Some value, got None"
  }
}

/// Assert that an Option is None
pub fn assert_none(option: Option(a)) -> Nil {
  case option {
    Some(_) -> panic as "Expected None, got Some"
    None -> Nil
  }
}

/// Assert that an Option contains a specific value
pub fn assert_some_equal(option: Option(a), expected: a) -> Nil {
  case option {
    Some(value) -> {
      value
      |> should.equal(expected)
    }
    None -> panic as "Expected Some value, got None"
  }
}

// ============================================================================
// QueryResult Assertion Helpers
// ============================================================================

/// Assert that a QueryResult has a specific row count
pub fn assert_row_count(result: node_pg.QueryResult, expected: Int) -> Nil {
  case result.row_count {
    Some(count) -> {
      count
      |> should.equal(expected)
    }
    None -> {
      panic as "Expected Some row count, got None"
    }
  }
}

/// Assert that a QueryResult has a specific command
pub fn assert_command(result: node_pg.QueryResult, expected: String) -> Nil {
  result.command
  |> should.equal(expected)
}

/// Assert that a QueryResult has fields
pub fn assert_has_fields(result: node_pg.QueryResult) -> Nil {
  case result.fields {
    Some(_) -> Nil
    None -> panic as "Expected Some fields, got None"
  }
}

// ============================================================================
// DatabaseError Assertion Helpers
// ============================================================================

/// Assert that a DatabaseError has a specific error code
pub fn assert_error_code(error: node_pg.DatabaseError, expected: String) -> Nil {
  case error.code {
    Some(code) -> {
      code
      |> should.equal(expected)
    }
    None -> {
      panic as "Expected Some error code, got None"
    }
  }
}

/// Assert that a DatabaseError has a non-empty message
pub fn assert_has_message(error: node_pg.DatabaseError) -> Nil {
  error.message
  |> should.not_equal("")
}

/// Assert that a DatabaseError has detail
pub fn assert_has_detail(error: node_pg.DatabaseError) -> Nil {
  case error.detail {
    Some(detail) -> {
      detail
      |> should.not_equal("")
    }
    None -> {
      panic as "Expected Some detail, got None"
    }
  }
}

/// Assert that a DatabaseError has hint
pub fn assert_has_hint(error: node_pg.DatabaseError) -> Nil {
  case error.hint {
    Some(hint) -> {
      hint
      |> should.not_equal("")
    }
    None -> {
      panic as "Expected Some hint, got None"
    }
  }
}
