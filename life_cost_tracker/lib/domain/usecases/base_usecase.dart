// base_usecase.dart
// LifeCostTracker
// Created by LifeCostTracker Team

abstract class BaseUseCase<Type, Params> {
  Future<Type> call(Params params);
}

class NoParams {}
