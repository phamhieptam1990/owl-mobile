class ProviderCommon {
  int totalLength = 0;
  int currentPage = 0;
  String keyword = '';
  bool enablePullUp = true;
  bool isSearch = false;
  bool isFirstEnter = true;
  String title = '';
  String lastKeywordSearch = '';

  clearData() {
    currentPage = 0;
    totalLength = 0;
    keyword = '';
    enablePullUp = true;
    isSearch = false;
    isFirstEnter = true;
    title = '';
    lastKeywordSearch = '';
  }
}
