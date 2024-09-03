import 'dart:ffi';
import 'package:ffi/ffi.dart';

typedef RunCpp = Bool Function(Pointer<Utf8>);
typedef RunDart = bool Function(Pointer<Utf8>);

class Network {

  late final DynamicLibrary _networkLib;

  Network() {
    _networkLib = DynamicLibrary.open("./windows/EggSpector.dll");
  }

  bool run(String path) {
    final RunDart run = _networkLib.lookupFunction<RunCpp, RunDart>("checkIfDamaged");
    final Pointer<Utf8> cPath = path.toNativeUtf8();
    final bool result = run(cPath);
    calloc.free(cPath);
    return result;
  }
}