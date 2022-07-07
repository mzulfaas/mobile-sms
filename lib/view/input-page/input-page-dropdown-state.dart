class InputPageDropdownState<T> {
  List<T> choiceList;
  T selectedChoice;
  int loadingState;

  InputPageDropdownState({
    this.choiceList = const [],
    this.selectedChoice,
    this.loadingState = 0
  });

  InputPageDropdownState<T> copy({
    List<T> choiceList,
    String selectedChoice,
    int loadingState
  }) {
    return InputPageDropdownState(
      choiceList: choiceList ?? this.choiceList,
      selectedChoice: selectedChoice ?? this.selectedChoice,
      loadingState: loadingState ?? this.loadingState
    );
  }
}