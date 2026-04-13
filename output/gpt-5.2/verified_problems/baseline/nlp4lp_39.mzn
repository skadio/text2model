int: K;
int: M;

float: AlloyQuantity;
array[1..M] of float: Target;
array[1..K, 1..M] of float: Ratio;
array[1..K] of float: Price;

array[1..K] of var float: x; % amount (lb) of each available alloy to use

constraint
  forall(k in 1..K)(x[k] >= 0.0);

% Total produced quantity
constraint
  sum(k in 1..K)(x[k]) = AlloyQuantity;

% Meet target quantity of each metal exactly
constraint
  forall(m in 1..M)(
    sum(k in 1..K)(x[k] * Ratio[k,m]) = Target[m]
  );

var float: TotalCost = sum(k in 1..K)(x[k] * Price[k]);

solve minimize TotalCost;

output [
  "TotalCost=", show(TotalCost), "\n",
  "x=", show(x), "\n"
];