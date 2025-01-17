// RUN: flatbuffer_translate -mlir-to-tflite-flatbuffer %s -o - | flatbuffer_translate --tflite-flatbuffer-to-mlir - -o - | FileCheck --dump-input-on-failure %s
// Ensure constants roundtrip exactly

func @bool() -> tensor<4xi1> {
  // CHECK-LABEL: @bool
  // CHECK: value = dense<[false, true, true, false]> : tensor<4xi1>
  %0 = "tfl.pseudo_const"() { value = dense<[false, true, true, false]> : tensor<4xi1> } : () -> tensor<4xi1>
  return %0 : tensor<4xi1>
}

func @complex64() -> tensor<4x!tf.complex64> {
  // CHECK-LABEL: @complex64
  // CHECK: value = opaque<"tf", "0x746674656E736F722464747970653A2044545F434F4D504C455836342074656E736F725F7368617065207B2064696D207B2073697A653A2034207D207D2074656E736F725F636F6E74656E743A20225C3030305C3030305C3230303F5C3030305C3030305C3230303F5C3030305C3030305C303030405C3030305C3030305C303030405C3030305C30303040405C3030305C30303040405C3030305C3030305C323030405C3030305C3030305C3230304022"> : tensor<4x!tf.complex64>
  %0 = "tfl.pseudo_const"() { value = opaque<"tf", "0x746674656E736F722464747970653A2044545F434F4D504C455836342074656E736F725F7368617065207B2064696D207B2073697A653A2034207D207D2074656E736F725F636F6E74656E743A20225C3030305C3030305C3230303F5C3030305C3030305C3230303F5C3030305C3030305C303030405C3030305C3030305C303030405C3030305C30303040405C3030305C30303040405C3030305C3030305C323030405C3030305C3030305C3230304022"> : tensor<4x!tf.complex64> } : () -> tensor<4x!tf.complex64>
  return %0 : tensor<4x!tf.complex64>
}

// TODO(b/138847107) this should work but doesn't
// func @f16() -> tensor<4xf16> {
//   %0 = "tfl.pseudo_const"() { value = dense<[1.0, 2.0, 3.0, 4.0]> : tensor<4xf16> } : () -> tensor<4xf16>
//   return %0 : tensor<4xf16>
// }

func @f32() -> tensor<4xf32> {
  // CHECK-LABEL: @f32
  // CHECK: value = dense<[1.000000e+00, 2.000000e+00, 3.000000e+00, 4.000000e+00]> : tensor<4xf32>
  %0 = "tfl.pseudo_const"() { value = dense<[1.0, 2.0, 3.0, 4.0]> : tensor<4xf32> } : () -> tensor<4xf32>
  return %0 : tensor<4xf32>
}

func @i8() -> tensor<4xi8> {
  // CHECK-LABEL: @i8
  // CHECK: value = dense<[1, 2, 3, 4]> : tensor<4xi8>
  %0 = "tfl.pseudo_const" () { value = dense<[1, 2, 3, 4]> : tensor<4xi8> } : () -> tensor<4xi8>
  return %0 : tensor<4xi8>
}

func @i16() -> tensor<4xi16> {
  // CHECK-LABEL: @i16
  // CHECK: value = dense<[1, 2, 3, 258]> : tensor<4xi16>
  %0 = "tfl.pseudo_const" () { value = dense<[1, 2, 3, 258]> : tensor<4xi16> } : () -> tensor<4xi16>
  return %0 : tensor<4xi16>
}

func @i32() -> tensor<4xi32> {
  // CHECK-LABEL: @i32
  // CHECK: value = dense<[1, 2, 3, 16909060]> : tensor<4xi32>
  // Check bytes come back in the right order
  %0 = "tfl.pseudo_const" () { value = dense<[1, 2, 3, 16909060]> : tensor<4xi32> } : () -> tensor<4xi32>
  return %0 : tensor<4xi32>
}

func @i64() -> tensor<4xi64> {
  // CHECK-LABEL: @i64
  // CHECK: value = dense<[1, 2, 3, 72623859790382856]> : tensor<4xi64>
  %0 = "tfl.pseudo_const" () { value = dense<[1, 2, 3, 72623859790382856]> : tensor<4xi64> } : () -> tensor<4xi64>
  return %0 : tensor<4xi64>
}

// TODO(krzysd) Add a test for strings. This isn't too urgent, since they use
// the same sort of opaque round-trip we get for complex64, but it might be good
// to check

func @uint8() -> tensor<4x!tf.uint8> {
  // CHECK-LABEL: @uint8
  // CHECK: value = opaque<"tf", "0x746674656E736F722464747970653A2044545F55494E54382074656E736F725F7368617065207B2064696D207B2073697A653A2034207D207D2074656E736F725F636F6E74656E743A20225C3333365C3235355C3237365C33353722"> : tensor<4x!tf.uint8>
  %0 = "tfl.pseudo_const"() { value = opaque<"tf", "0x746674656E736F722464747970653A2044545F55494E54382074656E736F725F7368617065207B2064696D207B2073697A653A2034207D207D2074656E736F725F636F6E74656E743A20225C3333365C3235355C3237365C33353722"> : tensor<4x!tf.uint8> } : () -> tensor<4x!tf.uint8>
  return %0 : tensor<4x!tf.uint8>
}

// Identity function to make the exporter happy
func @main(%arg0: tensor<4xi8>) -> tensor<4xi8> {
  %0 = "tfl.pseudo_input"(%arg0) : (tensor<4xi8>) -> tensor<4xi8>
  return %0 : tensor<4xi8>
}
