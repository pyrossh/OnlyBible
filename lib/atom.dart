import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:get_storage/get_storage.dart";

class Atom<T> extends ValueNotifier<T> {
  final String key;
  final GetStorage? box;
  Function()? set;
  Function(T)? update;

  Atom({required this.key, required T initialValue, this.box, this.set, this.update})
      : super(box != null ? box.read<T>(key) ?? initialValue : initialValue);

  @override
  set value(T newValue) {
    super.value = newValue;
    if (box != null) {
      if (newValue == null) {
        box!.remove(key);
      } else {
        box!.write(key, newValue);
      }
      box!.save();
    }
  }

  T watch(BuildContext context) {
    final elementRef = WeakReference(context as Element);
    final listenerWrapper = _ListenerWrapper();
    listenerWrapper.listener = () {
      assert(
        SchedulerBinding.instance.schedulerPhase != SchedulerPhase.persistentCallbacks,
        """
            Do not mutate state (by setting the value of the ValueNotifier 
            that you are subscribed to) during a `build` method. If you need 
            to schedule a value update after `build` has completed, use 
            `SchedulerBinding.instance.scheduleTask(updateTask, Priority.idle)`, 
            `SchedulerBinding.addPostFrameCallback(updateTask)`, '
          or similar.
          """,
      );
      // If the element has not been garbage collected (causing
      // `elementRef.target` to be null), or unmounted
      if (elementRef.target?.mounted ?? false) {
        // Mark the element as needing to be rebuilt
        elementRef.target!.markNeedsBuild();
      }
      // Remove the listener -- only listen to one change per `build`
      removeListener(listenerWrapper.listener!);
    };
    addListener(listenerWrapper.listener!);
    return value;
  }

  /// Use this method to notify listeners of deeper changes, e.g. when a value
  /// is added to or removed from a set which is stored in the value of a
  /// `ValueNotifier<Set<T>>`.
  void notifyChanged() {
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    notifyListeners();
  }
}

class _ListenerWrapper {
  void Function()? listener;
}

class AsyncAtom<T> extends ValueNotifier<T> {
  final T Function(T) callback;

  AsyncAtom(super._value, this.callback);

  @override
  get value {
    return callback(this.value);
  }

  T watch(BuildContext context) {
    final elementRef = WeakReference(context as Element);
    final listenerWrapper = _ListenerWrapper();
    listenerWrapper.listener = () {
      assert(
      SchedulerBinding.instance.schedulerPhase != SchedulerPhase.persistentCallbacks,
      """
            Do not mutate state (by setting the value of the ValueNotifier 
            that you are subscribed to) during a `build` method. If you need 
            to schedule a value update after `build` has completed, use 
            `SchedulerBinding.instance.scheduleTask(updateTask, Priority.idle)`, 
            `SchedulerBinding.addPostFrameCallback(updateTask)`, '
          or similar.
          """,
      );
      // If the element has not been garbage collected (causing
      // `elementRef.target` to be null), or unmounted
      if (elementRef.target?.mounted ?? false) {
        // Mark the element as needing to be rebuilt
        elementRef.target!.markNeedsBuild();
      }
      // Remove the listener -- only listen to one change per `build`
      removeListener(listenerWrapper.listener!);
    };
    addListener(listenerWrapper.listener!);
    return value;
  }
}