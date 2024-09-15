//TODO replace all direct references with usage of appData
//settings
import 'package:flutter/material.dart';

int currencyIndex = 0;

//internal data
DateTime earliestEntryDate = DateTime.now();

bool legacyDateSelector = false;

int defaultAccountId = -1;

int defaultDatePeriodEntries = 0;
int defaultDatePeriodStats = 2;
int defaultDatePeriodGroups = 2;
int defaultDatePeriodAccounts = 0;

ThemeMode themeMode = ThemeMode.system;
