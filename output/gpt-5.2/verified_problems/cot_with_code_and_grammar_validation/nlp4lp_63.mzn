int: N;
int: M;

array[1..N] of int: Cost;
array[1..N, 1..M] of 0..1: TranslatorLanguagesMatrix;

array[1..M] of string: RequiredLanguages;

array[1..N] of var 0..1: Select;

var int: TotalCost;

constraint forall(j in 1..M) (
  sum(i in 1..N) (Select[i] * TranslatorLanguagesMatrix[i, j]) >= 1
);

constraint TotalCost = sum(i in 1..N) (Select[i] * Cost[i]);

solve minimize TotalCost;