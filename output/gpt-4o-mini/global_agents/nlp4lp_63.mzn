include "globals.mzn";

int: N;  % Number of translators
array[1..N] of int: Cost;  % Cost of each translator
int: M;  % Number of required languages
array[1..M] of string: RequiredLanguages;  % List of required languages
array[1..N, 1..M] of int: TranslatorLanguagesMatrix;  % Binary decision matrix

% Decision variable: whether to select translator i
array[1..N] of var 0..1: selected;

% Objective: minimize total cost
var int: totalCost = sum(i in 1..N)(Cost[i] * selected[i]);

% Constraints: ensure all required languages are covered
array[1..M] of var 0..1: languageCovered;  % Whether each required language is covered

% For each required language, ensure at least one translator can translate it
constraint forall(j in 1..M)(
    languageCovered[j] = sum(i in 1..N)(TranslatorLanguagesMatrix[i, j] * selected[i]) > 0
);

% Ensure all required languages are covered
constraint all_different(languageCovered);

% Solve the model
solve minimize totalCost;

% Output the selected translators and the total cost
output [
    "Selected Translators: ", show([i | i in 1..N where selected[i] == 1]), "\n",
    "Total Cost: ", show(totalCost), "\n"
];