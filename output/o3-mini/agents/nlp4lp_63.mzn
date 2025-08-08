include "globals.mzn";

% Input data
int: N;
array[1..N] of int: Cost;
int: M;
array[1..N, 1..M] of int: TranslatorLanguagesMatrix;
array[1..M] of string: RequiredLanguages;

% Decision variables: select[i] = 1 if translator i is chosen, 0 otherwise
array[1..N] of var 0..1: select;

% For each required language j, ensure at least one selected translator can cover it.
constraint
  forall(j in 1..M) (
    sum(i in 1..N)(TranslatorLanguagesMatrix[i, j] * select[i]) >= 1
  );

% Define the total cost and minimize it.
var int: total_cost = sum(i in 1..N)(Cost[i] * select[i]);

solve minimize total_cost;

output [
  "Total cost: ", show(total_cost), "\n",
  "Selected translators (1 means selected): ", show(select), "\n"
];