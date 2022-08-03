import 'package:mobile_sms/models/promotion-program-input-state.dart';

class InputPageWrapper {
  List<PromotionProgramInputState> promotionProgramInputState;
  bool isAddItem;

  InputPageWrapper({
    this.promotionProgramInputState,
    this.isAddItem
  });

  InputPageWrapper copy({
    List<PromotionProgramInputState> promotionProgramInputState,
    bool isAddItem
  }) {
    return InputPageWrapper(
      promotionProgramInputState: promotionProgramInputState ?? this.promotionProgramInputState,
      isAddItem: isAddItem ?? this.isAddItem
    );
  }
}