% Parameters
int: K;
int: M;
float: AlloyQuantity;
array[1..M] of float: Target;
array[1..K, 1..M] of float: Ratio;
array[1..K] of float: Price;

set of int: Alloys = 1..K;
set of int: Metals = 1..M;

% Variables
array[Alloys] of var 0.0..AlloyQuantity: Quantity;

% Constraints
constraint
  sum(k in Alloys)(Quantity[k]) = AlloyQuantity;

constraint
  forall(m in Metals)(
    sum(k in Alloys)(Quantity[k] * Ratio[k, m]) = Target[m]
  );

% Objective
solve minimize sum(k in Alloys)(Quantity[k] * Price[k]);