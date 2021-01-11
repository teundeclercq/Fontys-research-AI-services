class CvDetail {
  String name;
  int usageInPercentage;
  List<String> synonyms;
  double grading;

  CvDetail(this.name, this.usageInPercentage, this.synonyms) {
    calculateGrading();
  }

  void calculateGrading() {
    print((usageInPercentage / 100));
    grading = (usageInPercentage / 100);
  }
}
