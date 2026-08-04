import 'package:flutter/material.dart';

import '../models/tool_item.dart';

IconData iconDataFor(ToolIcon icon) {
  return switch (icon) {
    ToolIcon.picture_as_pdf => Icons.picture_as_pdf_rounded,
    ToolIcon.document_scanner => Icons.document_scanner_rounded,
    ToolIcon.edit_document => Icons.edit_document,
    ToolIcon.auto_awesome => Icons.auto_awesome_rounded,
    ToolIcon.calculate => Icons.calculate_rounded,
    ToolIcon.swap_horiz => Icons.swap_horiz_rounded,
  };
}
