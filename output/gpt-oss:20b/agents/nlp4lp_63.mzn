include "globals.mzn";

/* Data – supplied in a .dzn file */
int: N;                                 % number of translators
int: M;                                 % number of required languages
array[1..N] of int: Cost;              % cost of each translator
array[1..N, 1..M] of int: TranslatorLanguagesMatrix;   % 0/1 matrix
array[1..M] of string: RequiredLanguages;

/* Decision variables */
array[1..N] of var 0..1: select;        % 1 = translator selected

/* Constraints – every required language must be covered by at least one
   selected translator */
constraint
  forall(j in 1..M) (
    sum(i in 1..N) (select[i] * TranslatorLanguagesMatrix[i][j]) >= 1
  );

/* Objective – minimise total cost */
var int: totalCost = sum(i in 1..N) (select[i] * Cost[i]);

solve minimize totalCost;

/* Output */
output [
  "Selected translators: ", show([i | i in 1..N where select[i] = 1]), "\n",
  "Total cost = ", show(totalCost), "\n"
];