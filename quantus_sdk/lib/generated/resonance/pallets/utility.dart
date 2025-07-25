// ignore_for_file: no_leading_underscores_for_library_prefixes
import '../types/pallet_utility/pallet/call.dart' as _i2;
import '../types/quantus_runtime/origin_caller.dart' as _i3;
import '../types/quantus_runtime/runtime_call.dart' as _i1;
import '../types/sp_weights/weight_v2/weight.dart' as _i4;

class Txs {
  const Txs();

  /// Send a batch of dispatch calls.
  ///
  /// May be called from any origin except `None`.
  ///
  /// - `calls`: The calls to be dispatched from the same origin. The number of call must not
  ///  exceed the constant: `batched_calls_limit` (available in constant metadata).
  ///
  /// If origin is root then the calls are dispatched without checking origin filter. (This
  /// includes bypassing `frame_system::Config::BaseCallFilter`).
  ///
  /// ## Complexity
  /// - O(C) where C is the number of calls to be batched.
  ///
  /// This will return `Ok` in all circumstances. To determine the success of the batch, an
  /// event is deposited. If a call failed and the batch was interrupted, then the
  /// `BatchInterrupted` event is deposited, along with the number of successful calls made
  /// and the error of the failed call. If all were successful, then the `BatchCompleted`
  /// event is deposited.
  _i1.Utility batch({required List<_i1.RuntimeCall> calls}) {
    return _i1.Utility(_i2.Batch(calls: calls));
  }

  /// Send a call through an indexed pseudonym of the sender.
  ///
  /// Filter from origin are passed along. The call will be dispatched with an origin which
  /// use the same filter as the origin of this call.
  ///
  /// NOTE: If you need to ensure that any account-based filtering is not honored (i.e.
  /// because you expect `proxy` to have been used prior in the call stack and you do not want
  /// the call restrictions to apply to any sub-accounts), then use `as_multi_threshold_1`
  /// in the Multisig pallet instead.
  ///
  /// NOTE: Prior to version *12, this was called `as_limited_sub`.
  ///
  /// The dispatch origin for this call must be _Signed_.
  _i1.Utility asDerivative({
    required int index,
    required _i1.RuntimeCall call,
  }) {
    return _i1.Utility(_i2.AsDerivative(
      index: index,
      call: call,
    ));
  }

  /// Send a batch of dispatch calls and atomically execute them.
  /// The whole transaction will rollback and fail if any of the calls failed.
  ///
  /// May be called from any origin except `None`.
  ///
  /// - `calls`: The calls to be dispatched from the same origin. The number of call must not
  ///  exceed the constant: `batched_calls_limit` (available in constant metadata).
  ///
  /// If origin is root then the calls are dispatched without checking origin filter. (This
  /// includes bypassing `frame_system::Config::BaseCallFilter`).
  ///
  /// ## Complexity
  /// - O(C) where C is the number of calls to be batched.
  _i1.Utility batchAll({required List<_i1.RuntimeCall> calls}) {
    return _i1.Utility(_i2.BatchAll(calls: calls));
  }

  /// Dispatches a function call with a provided origin.
  ///
  /// The dispatch origin for this call must be _Root_.
  ///
  /// ## Complexity
  /// - O(1).
  _i1.Utility dispatchAs({
    required _i3.OriginCaller asOrigin,
    required _i1.RuntimeCall call,
  }) {
    return _i1.Utility(_i2.DispatchAs(
      asOrigin: asOrigin,
      call: call,
    ));
  }

  /// Send a batch of dispatch calls.
  /// Unlike `batch`, it allows errors and won't interrupt.
  ///
  /// May be called from any origin except `None`.
  ///
  /// - `calls`: The calls to be dispatched from the same origin. The number of call must not
  ///  exceed the constant: `batched_calls_limit` (available in constant metadata).
  ///
  /// If origin is root then the calls are dispatch without checking origin filter. (This
  /// includes bypassing `frame_system::Config::BaseCallFilter`).
  ///
  /// ## Complexity
  /// - O(C) where C is the number of calls to be batched.
  _i1.Utility forceBatch({required List<_i1.RuntimeCall> calls}) {
    return _i1.Utility(_i2.ForceBatch(calls: calls));
  }

  /// Dispatch a function call with a specified weight.
  ///
  /// This function does not check the weight of the call, and instead allows the
  /// Root origin to specify the weight of the call.
  ///
  /// The dispatch origin for this call must be _Root_.
  _i1.Utility withWeight({
    required _i1.RuntimeCall call,
    required _i4.Weight weight,
  }) {
    return _i1.Utility(_i2.WithWeight(
      call: call,
      weight: weight,
    ));
  }
}

class Constants {
  Constants();

  /// The limit on the number of batched calls.
  final int batchedCallsLimit = 10922;
}
