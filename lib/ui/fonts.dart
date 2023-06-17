import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:budgetron/ui/colors.dart';

class BudgetronFonts {
  // for text
  static TextStyle nunitoSize14Weight400 = TextStyle(
      fontFamily: GoogleFonts.nunito().fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: BudgetronColors.black);

  static TextStyle nunitoSize16Weight300 = TextStyle(
      fontFamily: GoogleFonts.nunito().fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w300,
      color: BudgetronColors.black);
  static TextStyle nunitoSize16Weight400 = TextStyle(
      fontFamily: GoogleFonts.nunito().fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: BudgetronColors.black);
  static TextStyle nunitoSize16Weight600 = TextStyle(
      fontFamily: GoogleFonts.nunito().fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: BudgetronColors.black);
  static TextStyle nunitoSize18Weight600 = TextStyle(
      fontFamily: GoogleFonts.nunito().fontFamily,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: BudgetronColors.black);

  // for custom buttons
  static TextStyle nunitoSize16Weight600Hint = TextStyle(
      fontFamily: GoogleFonts.nunito().fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: BudgetronColors.gray4);

  // for input fields
  static TextStyle robotoSize32Weight400 = TextStyle(
      fontFamily: GoogleFonts.roboto().fontFamily,
      fontSize: 32,
      fontWeight: FontWeight.w400,
      color: BudgetronColors.black);

  static TextStyle robotoSize32Weight400Hint = TextStyle(
      fontFamily: GoogleFonts.roboto().fontFamily,
      fontSize: 32,
      fontWeight: FontWeight.w400,
      color: BudgetronColors.gray4);

  static TextStyle nunitoSize14Weight400Hint = TextStyle(
      fontFamily: GoogleFonts.nunito().fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: BudgetronColors.gray4);
}
