include "globals.mzn";

%-----------------------------
% Input data
%-----------------------------
int: N;                          % number of translators
int: M;                          % number of required languages

array[1..N] of int: Cost;        % cost of translator i

% Binary matrix: 1 if translator i can translate language j, else 0
array[1..N, 1..M] of int: TranslatorLanguagesMatrix;

% Names of required languages (for output readability)
array[1..M] of string: RequiredLanguages;

%-----------------------------
% Decision variables
%-----------------------------
array[1..N] of var 0..1: select;  % 1 if translator i is selected

%-----------------------------
% Constraints: cover all languages
%-----------------------------
constraint
  forall(j in 1..M)(
    sum(i in 1..N)(select[i] * TranslatorLanguagesMatrix[i,j]) >= 1
  );

%-----------------------------
% Objective: minimize total cost
%-----------------------------
var int: total_cost = sum(i in 1..N)(select[i] * Cost[i]);

solve minimize total_cost;

%-----------------------------
% Output
%-----------------------------
output [
  "Total cost = ", show(total_cost), "\n",
  "Selected translators (1..N) = ",
  show([i | i in 1..N where fix(select[i]) = 1]), "\n",
  "Select vector = ", show(select), "\n",
  "Language coverage (RequiredLanguages):\n"
] ++
[
  RequiredLanguages[j] ++ ": " ++
  show(sum(i in 1..N)(fix(select[i]) * TranslatorLanguagesMatrix[i,j])) ++ "\n"
  | j in 1..M
];