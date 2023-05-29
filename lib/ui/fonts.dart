import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:budgetron/ui/colors.dart';

class BudgetronFonts {
  // for text
  static TextStyle nunitoSize14Weight400 = TextStyle(
      fontFamily: GoogleFonts.nunito().fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: BudgetronColors.gray1);

  static TextStyle nunitoSize16Weight300 = TextStyle(
      fontFamily: GoogleFonts.nunito().fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w300,
      color: BudgetronColors.gray1);
  static TextStyle nunitoSize16Weight400 = TextStyle(
      fontFamily: GoogleFonts.nunito().fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: BudgetronColors.gray1);
  static TextStyle nunitoSize16Weight600 = TextStyle(
      fontFamily: GoogleFonts.nunito().fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: BudgetronColors.gray1);

  // for buttons
  static TextStyle nunitoSize16Weight600Unused = TextStyle(
      fontFamily: GoogleFonts.nunito().fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: BudgetronColors.gray4);
}
