int: N;
int: M;

array[1..N] of float: Cost;
array[1..N, 1..M] of bool: TranslatorLanguagesMatrix;
array[1..M] of string: RequiredLanguages;

array[1..N] of var bool: TranslatorSelection;

constraint
  forall(l in 1..M) (
    exists(t in 1..N) (
      TranslatorSelection[t] /\ TranslatorLanguagesMatrix[t, l]
    )
  );

var float: TotalCost = sum(t in 1..N)(Cost[t] * bool2int(TranslatorSelection[t]));

solve minimize TotalCost;

output [
  "TotalCost=", show(TotalCost), "\n",
  "SelectedTranslators=", show([t | t in 1..N where fix(TranslatorSelection[t]) = 1]), "\n"
];