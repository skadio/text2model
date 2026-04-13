int: P;
int: C;

array[1..P] of int: Supply;
array[1..C] of int: Demand;
array[1..P, 1..C] of int: TransmissionCosts;

array[1..P, 1..C] of var 0..max(Supply): Ship;

constraint
  forall(p in 1..P) (
    sum(c in 1..C)(Ship[p,c]) <= Supply[p]
  );

constraint
  forall(c in 1..C) (
    sum(p in 1..P)(Ship[p,c]) = Demand[c]
  );

var int: TotalCost = sum(p in 1..P, c in 1..C)(TransmissionCosts[p,c] * Ship[p,c]);

solve minimize TotalCost;

output [
  "TotalCost = ", show(TotalCost), "\n",
  "Ship =\n",
  concat([ concat([ show(Ship[p,c]) ++ if c == C then "\n" else " " endif | c in 1..C]) | p in 1..P ])
];