import 'package:CvPrototype/models/tip.dart';
import 'package:flutter/material.dart';

class Tips {
  List<Tip> tips = [
    new Tip(
        'Zet een foto in je CV zodat een bedrijf gelijk een beeld van je hebt',
        Icons.add_photo_alternate),
    new Tip(
        'Zet je diploma`s en werkervaring van heden tot verleden (heden bovenaan)',
        Icons.format_list_numbered),
    new Tip(
        'Maak gebruik van een website die je makkelijk kan helpen bij het maken van cv.',
        Icons.art_track),
    new Tip('Zorg dat je cv niet langer is dan twee A4’tjes.', Icons.filter_2),
    new Tip(
        'Tevreden? Sla het op als pdf, dan kan er niks meer verspringen in de opmaak',
        Icons.picture_as_pdf),
    new Tip('Laat je iemand anders je cv checken', Icons.person),
  ];
}
