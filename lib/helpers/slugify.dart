final RegExp whiteSpacesRegExp = RegExp(r'(\s+)');
final RegExp specialCharsRegExp = RegExp(r'[\!\?&@\.,:*\(\)\[\]^%$/\\#~<>|}{]');

String slugify(String title) {
  return title
      .replaceAll(specialCharsRegExp, '')
      .replaceAll(whiteSpacesRegExp, "_")
      .toLowerCase();
}
