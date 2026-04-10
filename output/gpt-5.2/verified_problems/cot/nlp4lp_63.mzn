% Parameters
int: N;
int: M;

array[1..N] of int: Cost;

% Binary matrix: 1 if translator i can translate into required language j, else 0
array[1..N, 1..M] of int: TranslatorLanguagesMatrix;

array[1..M] of string: RequiredLanguages;

% Variables
array[1..N] of var 0..1: x;

var int: TotalCost;

% Constraints
constraint forall(i in 1..N, j in 1..M)(
  TranslatorLanguagesMatrix[i,j] >= 0 /\ TranslatorLanguagesMatrix[i,j] <= 1
);

% Each required language must be covered by at least one selected translator
constraint forall(j in 1..M)(
  sum(i in 1..N)(x[i] * TranslatorLanguagesMatrix[i,j]) >= 1
);

% Total cost
constraint TotalCost = sum(i in 1..N)(Cost[i] * x[i]);

% Objective
solve minimize TotalCost;