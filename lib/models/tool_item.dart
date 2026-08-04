enum ToolCategory {
  pdfConverter,
  ocr,
  editPdf,
  generators,
  calculators,
  converters,
}

enum ToolIcon {
  picture_as_pdf,
  document_scanner,
  edit_document,
  auto_awesome,
  calculate,
  swap_horiz,
}

class ToolItem {
  const ToolItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
  });

  final String id;
  final String name;
  final String description;
  final ToolCategory category;

  String get url => 'https://toolnova.tools/#tool=$id';
}

class ToolSection {
  const ToolSection({
    required this.category,
    required this.title,
    required this.colorValue,
    required this.icon,
    required this.tools,
  });

  final ToolCategory category;
  final String title;
  final int colorValue;
  final ToolIcon icon;
  final List<ToolItem> tools;
}
