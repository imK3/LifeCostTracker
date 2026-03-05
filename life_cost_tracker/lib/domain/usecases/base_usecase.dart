// base_usecase.dart
// LifeCostTracker
// Created by LifeCostTracker Team

/// Base use case abstract class
/// 基础用例抽象类
abstract class BaseUseCase<Type, Params> {
  /// Execute the use case
  /// 执行用例
  Future<Type> call(Params params);
}

/// No parameters class for use cases that don't require parameters
/// 用于不需要参数的用例的无参数类
class NoParams {}
