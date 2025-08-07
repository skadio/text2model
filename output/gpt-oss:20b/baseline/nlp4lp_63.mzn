int: N;
int: M;
array[1..N] of int: Cost;
array[1..N, 1..M] of int: TranslatorLanguagesMatrix;
array[1..M] of string: RequiredLanguages;

array[1..N] of var bool: selected;

constraint
  forall(j in 1..M) (
    sum(i in 1..N) (TranslatorLanguagesMatrix[i][j] * bool2int(selected[i])) >= 1
  );

solve minimize
  sum(i in 1..N) (Cost[i] * bool2int(selected[i]));

output [
  "Selected translators: ", show([i | i in 1..N where selected[i]]), "\n",
  "Total cost: ", show(sum(i in 1..N) (Cost[i] * bool2int(selected[i]))), "\n"
];