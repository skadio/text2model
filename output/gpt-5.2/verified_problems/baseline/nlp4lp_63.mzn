int: N;
int: M;

array[1..N] of int: Cost;
array[1..M] of string: RequiredLanguages;

array[1..N, 1..M] of int: TranslatorLanguagesMatrix; % 0/1

array[1..N] of var bool: select;

constraint
  forall(l in 1..M) (
    sum(t in 1..N) (bool2int(select[t]) * TranslatorLanguagesMatrix[t,l]) >= 1
  );

var int: total_cost = sum(t in 1..N) (bool2int(select[t]) * Cost[t]);

solve minimize total_cost;

output [
  "TotalCost = ", show(total_cost), "\n",
  "SelectedTranslators (1-based) = ", show([t | t in 1..N where fix(select[t])]), "\n",
  "SelectedVector = ", show([bool2int(select[t]) | t in 1..N]), "\n"
];