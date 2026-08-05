import '../models/plan_model.dart';
import '../models/subscription_model.dart';

abstract interface class SubscriptionRemoteDataSource {
  Future<List<PlanModel>> getPlans();

  Future<SubscriptionModel> getCurrentSubscription();

  Future<String> initializePayment(
    int planId,
  );
}