int: K;
int: M;

set of int: ALLOYS = 1..K;
set of int: METALS = 1..M;

float: AlloyQuantity;
array[METALS] of float: Target;
array[ALLOYS, METALS] of float: Ratio;
array[ALLOYS] of float: Price;

array[ALLOYS] of var float: AlloyCombination;

constraint forall(a in ALLOYS) (AlloyCombination[a] >= 0.0);

% Total quantity produced must match required quantity
constraint sum(a in ALLOYS)(AlloyCombination[a]) = AlloyQuantity;

% Composition constraints: meet target quantity of each metal
constraint forall(m in METALS) (
  sum(a in ALLOYS)(AlloyCombination[a] * Ratio[a,m]) = Target[m]
);

var float: TotalCost = sum(a in ALLOYS)(AlloyCombination[a] * Price[a]);

solve minimize TotalCost;

output [
  "TotalCost = ", show(TotalCost), "\n",
  "AlloyCombination = ", show(AlloyCombination), "\n"
];