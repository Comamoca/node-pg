import gleeunit/should

// FFI helper function tests
// These test the type conversion functions in ffi.mjs

@external(javascript, "./ffi.mjs", "testListToArray")
fn list_to_array_ffi(list: List(a)) -> List(a)

@external(javascript, "./ffi.mjs", "testArrayToList")
fn array_to_list_ffi(values: List(a)) -> List(a)

// Test: Gleam List → JavaScript Array → Gleam List (round trip)
pub fn list_array_roundtrip_test() {
  let original_list = [1, 2, 3, 4, 5]
  let result = list_to_array_ffi(original_list)

  result
  |> should.equal(original_list)
}

// Test: Empty list conversion
pub fn empty_list_conversion_test() {
  let empty_list: List(Int) = []
  let result = list_to_array_ffi(empty_list)

  result
  |> should.equal([])
}

// Test: String list conversion
pub fn string_list_conversion_test() {
  let string_list = ["hello", "world", "gleam"]
  let result = list_to_array_ffi(string_list)

  result
  |> should.equal(string_list)
}

// Test: Array → List conversion
pub fn array_to_list_test() {
  let values = [10, 20, 30]
  let result = array_to_list_ffi(values)

  result
  |> should.equal([10, 20, 30])
}
