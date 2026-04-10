% Parameters
int: N;                                   % Number of translators
array[1..N] of int: Cost;                 % Cost of translator i

int: M;                                   % Number of required languages
array[1..M] of string: RequiredLanguages;  % Names/codes of required languages (reference/output only)

% Binary matrix: 1 if translator i can translate into required language j, else 0
% NOTE: In the .dzn file, provide this as a proper 2D array, e.g.:
% TranslatorLanguagesMatrix = array2d(1..N, 1..M, [ ... N*M integers ... ]);
array[1..N, 1..M] of int: TranslatorLanguagesMatrix;

% Decision variables
array[1..N] of var 0..1: selectTranslator; % 1 if translator i is selected, else 0
var int: totalCost = sum(i in 1..N)(Cost[i] * selectTranslator[i]);

% Constraints
constraint
  forall(j in 1..M) (
    sum(i in 1..N)(TranslatorLanguagesMatrix[i,j] * selectTranslator[i]) >= 1
  );

% Objective
solve minimize totalCost;

% Optional output
output [
  "totalCost=", show(totalCost), "\n",
  "selectedTranslators=", show([i | i in 1..N where fix(selectTranslator[i]) = 1]), "\n"
];