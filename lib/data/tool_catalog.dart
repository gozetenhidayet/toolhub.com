import '../models/tool_item.dart';

const List<ToolSection> toolSections = [
  ToolSection(
    category: ToolCategory.pdfConverter,
    title: 'PDF Converter',
    colorValue: 0xFFE5484D,
    icon: ToolIcon.picture_as_pdf,
    tools: const [
      ToolItem(id: 'pdf2word', name: 'PDF to Word', description: 'Convert PDF files to editable Word documents instantly.', category: ToolCategory.pdfConverter),
      ToolItem(id: 'word2pdf', name: 'Word to PDF', description: 'Convert Word documents to PDF format. Fast and free.', category: ToolCategory.pdfConverter),
      ToolItem(id: 'pdf2jpg', name: 'PDF to JPG', description: 'Convert PDF pages to high quality JPG images.', category: ToolCategory.pdfConverter),
      ToolItem(id: 'img2pdf', name: 'JPG to PDF', description: 'Combine JPG images into a single PDF file.', category: ToolCategory.pdfConverter),
      ToolItem(id: 'pdf2excel', name: 'PDF to Excel', description: 'Extract tables from PDF into Excel spreadsheets.', category: ToolCategory.pdfConverter),
      ToolItem(id: 'pdf2png', name: 'PDF to PNG', description: 'Convert PDF pages to high-quality PNG images.', category: ToolCategory.pdfConverter),
      ToolItem(id: 'img2pdf', name: 'PNG to PDF', description: 'Convert PNG images to PDF documents instantly.', category: ToolCategory.pdfConverter),
      ToolItem(id: 'pdf2text', name: 'PDF to Text', description: 'Extract all text content from any PDF file.', category: ToolCategory.pdfConverter),
    ],
  ),
  ToolSection(
    category: ToolCategory.ocr,
    title: 'OCR Tools',
    colorValue: 0xFFE68A31,
    icon: ToolIcon.document_scanner,
    tools: const [
      ToolItem(id: 'ocr', name: 'Image to Text (OCR)', description: 'Extract text from images using browser-based OCR technology.', category: ToolCategory.ocr),
      ToolItem(id: 'scanocr', name: 'Scan PDF to Text', description: 'Make scanned PDFs searchable with OCR technology.', category: ToolCategory.ocr),
    ],
  ),
  ToolSection(
    category: ToolCategory.editPdf,
    title: 'Edit PDF',
    colorValue: 0xFF8259F5,
    icon: ToolIcon.edit_document,
    tools: const [
      ToolItem(id: 'merge', name: 'Merge PDF', description: 'Combine multiple PDF files into one document.', category: ToolCategory.editPdf),
      ToolItem(id: 'split', name: 'Split PDF', description: 'Split a PDF into multiple separate files.', category: ToolCategory.editPdf),
      ToolItem(id: 'compress', name: 'Compress PDF', description: 'Re-optimize a PDF to reduce its file size when possible.', category: ToolCategory.editPdf),
      ToolItem(id: 'rotate', name: 'Rotate PDF', description: 'Rotate PDF pages to any angle. 90, 180, 270 degrees.', category: ToolCategory.editPdf),
      ToolItem(id: 'deletepages', name: 'Delete PDF Pages', description: 'Remove unwanted pages from your PDF file.', category: ToolCategory.editPdf),
      ToolItem(id: 'extractpages', name: 'Extract PDF Pages', description: 'Extract specific pages from a PDF document.', category: ToolCategory.editPdf),
      ToolItem(id: 'sign', name: 'Sign PDF', description: 'Draw, type or upload your signature and place it on any PDF page.', category: ToolCategory.editPdf),
      ToolItem(id: 'addtext', name: 'Add Text to PDF', description: 'Type anywhere on a page — fill forms, add notes, annotate.', category: ToolCategory.editPdf),
    ],
  ),
  ToolSection(
    category: ToolCategory.generators,
    title: 'Generators',
    colorValue: 0xFF246BEE,
    icon: ToolIcon.auto_awesome,
    tools: const [
      ToolItem(id: 'qr', name: 'QR Code Generator', description: 'Turn any URL or text into a QR code. Download as PNG instantly.', category: ToolCategory.generators),
      ToolItem(id: 'password', name: 'Password Generator', description: 'Strong, secure passwords of any length. Symbols, numbers, uppercase.', category: ToolCategory.generators),
      ToolItem(id: 'color', name: 'Color Code Converter', description: 'Convert between HEX, RGB, and HSL color formats instantly.', category: ToolCategory.generators),
      ToolItem(id: 'hash', name: 'Lorem Ipsum Generator', description: 'Generate placeholder text for designs and prototypes.', category: ToolCategory.generators),
    ],
  ),
  ToolSection(
    category: ToolCategory.calculators,
    title: 'Calculators',
    colorValue: 0xFF1AAE6F,
    icon: ToolIcon.calculate,
    tools: const [
      ToolItem(id: 'age', name: 'Age Calculator', description: 'Your exact age in years, months, days and hours.', category: ToolCategory.calculators),
      ToolItem(id: 'bmi', name: 'BMI Calculator', description: 'Body Mass Index with US Imperial and Metric support.', category: ToolCategory.calculators),
      ToolItem(id: 'tip', name: 'Tip Calculator', description: 'Split the bill and calculate tips for any group size.', category: ToolCategory.calculators),
      ToolItem(id: 'discount', name: 'Discount Calculator', description: 'Final price after any percentage discount. Quick math.', category: ToolCategory.calculators),
      ToolItem(id: 'loan', name: 'Loan Calculator', description: 'Monthly payment, total interest on any loan. US-style.', category: ToolCategory.calculators),
      ToolItem(id: 'bmr', name: 'BMR Calculator', description: 'Your basal metabolic rate — calories burned at rest.', category: ToolCategory.calculators),
      ToolItem(id: 'calorie', name: 'Calorie Calculator', description: 'Daily calorie needs based on activity level (TDEE).', category: ToolCategory.calculators),
      ToolItem(id: 'bodyfat', name: 'Body Fat Calculator', description: 'Estimate body fat % using the US Navy tape method.', category: ToolCategory.calculators),
      ToolItem(id: 'water', name: 'Water Intake Calculator', description: 'Daily recommended water intake based on weight & activity.', category: ToolCategory.calculators),
    ],
  ),
  ToolSection(
    category: ToolCategory.converters,
    title: 'Converters',
    colorValue: 0xFF12AFA7,
    icon: ToolIcon.swap_horiz,
    tools: const [
      ToolItem(id: 'unit', name: 'Unit Converter', description: 'Length, weight, temperature, speed, volume — all units.', category: ToolCategory.converters),
      ToolItem(id: 'currency', name: 'Currency Converter', description: 'Estimate conversions between 15 major world currencies.', category: ToolCategory.converters),
      ToolItem(id: 'case', name: 'Text Case Converter', description: 'UPPER, lower, Title Case, camelCase in one click.', category: ToolCategory.converters),
      ToolItem(id: 'wordcount', name: 'Word Counter', description: 'Words, characters, sentences, and reading time — live.', category: ToolCategory.converters),
    ],
  ),
];

List<ToolItem> get allTools =>
    toolSections.expand((section) => section.tools).toList(growable: false);

ToolSection sectionFor(ToolCategory category) =>
    toolSections.firstWhere((section) => section.category == category);
