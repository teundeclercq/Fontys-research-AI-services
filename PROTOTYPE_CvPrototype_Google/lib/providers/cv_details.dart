import 'package:CvPrototype/models/cv_detail.dart';

class CvDetails {
  List<CvDetail> details = [
    new CvDetail("telefoonnummer", 90, ['telefoon', 'mobile']),
    new CvDetail("e-mailadres", 90, ['email', 'e-mail']),
    new CvDetail("adres", 80, null),
    new CvDetail("linkedin", 60, null),
    new CvDetail("geboortedatum", 50, null),
    new CvDetail("talen", 80, null),
    new CvDetail("interesses", 60, ['hobby']),
    new CvDetail("vaardigheden", 80, ['expertise', 'kennis']),
    new CvDetail("opleiding", 60, ['school', 'diploma']),
    new CvDetail("ervaring", 60, null),
  ];
}
