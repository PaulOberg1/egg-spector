import 'dart:ffi';
import 'package:ffi/ffi.dart';

typedef SimpleFunction = Int32 Function(Pointer<Utf8>);
typedef SimpleFunctionDart = int Function(Pointer<Utf8>);

class Network {
  late final DynamicLibrary _networkLib;

  Network() {
    _networkLib = DynamicLibrary.open("windows/EggSpector.dll");
  }

  int run(String path) {
    final SimpleFunctionDart run = _networkLib.lookupFunction<SimpleFunction, SimpleFunctionDart>("simpleFunction");
    final Pointer<Utf8> cPath = path.toNativeUtf8();
    final int result = run(cPath);
    calloc.free(cPath);
    return result;
  }
}