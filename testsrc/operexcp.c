int main() {
  void* (*fp)() = 0;

  fp(); /* boom */
  return 0;
}
