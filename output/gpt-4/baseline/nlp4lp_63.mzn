include "globals.mzn";

% Number of translators
int: N;

% Cost of each translator
array[1..N] of int: Cost;

% Number of required languages
int: M;

% Binary matrix representing the languages each translator can translate
array[1..N, 1..M] of 0..1: TranslatorLanguagesMatrix;

% Decision variable representing whether a translator is selected or not
array[1..N] of var 0..1: TranslatorSelected;

% Objective function to minimize the total cost
var int: TotalCost = sum(i in 1..N)(TranslatorSelected[i]*Cost[i]);

% Constraint to ensure all required languages can be translated
constraint forall(j in 1..M)(
  sum(i in 1..N)(TranslatorLanguagesMatrix[i,j]*TranslatorSelected[i]) >= 1
);

% Minimize the total cost
solve minimize TotalCost;

% Output the selected translators and the total cost
output ["Selected Translators: "] ++ [show(i) | i in 1..N where TranslatorSelected[i] = 1] ++ ["\nTotal Cost: ", show(TotalCost)];