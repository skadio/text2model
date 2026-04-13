int: N;
array[1..N] of int: Cost;

int: M;
array[1..M] of string: RequiredLanguages;

array[1..N, 1..M] of 0..1: TranslatorLanguagesMatrix;

array[1..N] of var 0..1: x;

var int: total_cost;

constraint forall(j in 1..M) (
  sum(i in 1..N)(TranslatorLanguagesMatrix[i, j] * x[i]) >= 1
);

constraint total_cost = sum(i in 1..N)(Cost[i] * x[i]);

solve minimize total_cost;