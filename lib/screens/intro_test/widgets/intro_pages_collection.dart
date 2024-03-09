import 'package:animated_introduction/animated_introduction.dart';

final List<SingleIntroScreen> pages = [
  const SingleIntroScreen(
    imageWithBubble: false,
    title: 'Znajdź swoje salony',
    description:
        "Odkryj świat nowych fryzur i relaksu. Znajdź idealne miejsce do odświeżenia swojego wyglądu i poczuj się jak milion dolarów!",
    imageAsset: 'assets/images/intro1.png',
  ),
  const SingleIntroScreen(
    imageWithBubble: false,
    title: 'Wszystkie salony i barberzy',
    description:
        "Niech Twoje poszukiwania idealnego salonu będą tak łatwe jak przeglądanie menu kawiarni.",
    imageAsset: 'assets/images/intro2.png',
  ),
  const SingleIntroScreen(
    imageWithBubble: false,
    title: 'Z kontem możesz więcej',
    description:
        'Zarejestruj się i otwórz drzwi do wyjątkowych ofert, zniżek i bonusów.',
    imageAsset: 'assets/images/intro3.png',
  ),
];
