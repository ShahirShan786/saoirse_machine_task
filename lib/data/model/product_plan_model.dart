class ProductPlanModel {
  bool? isSelected;
  double? planPayment;
  DateTime? startDate, endDate;
  String? paymentDuration, duration;

  ProductPlanModel({
    this.isSelected,
    this.planPayment,
    this.duration,
    this.startDate,
    this.endDate,
    this.paymentDuration,
  });
}

List<ProductPlanModel> productPlanList = [
  ProductPlanModel(
    duration: "166 Days",
    endDate: DateTime(2025, 12, 31),
    isSelected: false,
    startDate: DateTime.now(),
    paymentDuration: "EveryDay",
    planPayment: 200,
  ),
  ProductPlanModel(
    duration: "12 months",
    endDate: DateTime(2025, 12, 31),
    isSelected: false,
    startDate: DateTime.now(),
    paymentDuration: "monthly",
    planPayment: 2600,
  ),
  ProductPlanModel(
    duration: "6 months",
    endDate: DateTime(2025, 12, 31),
    isSelected: false,
    startDate: DateTime.now(),
    paymentDuration: "monthly",
    planPayment: 5332,
  ),
  ProductPlanModel(
    duration: "3 months",
    endDate: DateTime(2025, 12, 31),
    isSelected: false,
    startDate: DateTime.now(),
    paymentDuration: "monthly",
    planPayment: 10663,
  ),
];
