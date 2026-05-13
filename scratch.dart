void main() {
  try {
    List<int> list = [10];
    print(list[2]);
  } catch (e) {
    print("TEST 1: \$e");
  }

  try {
    List<int> list = [];
    list.removeAt(0);
  } catch (e) {
    print("TEST 2: \$e");
  }
}
