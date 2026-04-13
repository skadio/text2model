% Supply redistribution among hospitals (min-cost flow)

int: nHospitals = 7;
set of int: H = 1..nHospitals;

array[H] of int: stock    = [160, 353, 171, 193, 102, 429, 284];
array[H] of int: required = [ 19, 138, 110, 446, 341, 428,  47];

array[H,H] of int: cost =
  [|  0, 12, 47, 39,  4, 21, 31
   | 14,  0, 39, 12, 31, 29, 15
   | 15,  6,  0, 26, 12,  5,  3
   | 39, 47, 42,  0, 33, 48,  2
   | 35, 25, 46, 12,  0, 25, 45
   | 39, 28, 28, 11, 16,  0, 13
   | 42, 43, 49, 41, 41, 18,  0 |];

array[H] of int: surplus = [stock[h] - required[h] | h in H];

% Feasibility: total stock must cover total required
constraint sum(h in H)(surplus[h]) >= 0;

% Decision variables: shipments between hospitals (no self-shipment)
array[H,H] of var 0..max(stock): flow;
constraint forall(h in H)(flow[h,h] = 0);

% Do not ship out more than available surplus from any hospital
constraint forall(i in H)(
  sum(j in H)(flow[i,j]) <= max(0, surplus[i])
);

% Each hospital must receive enough to cover its deficit (if any)
constraint forall(j in H)(
  sum(i in H)(flow[i,j]) >= max(0, -surplus[j])
);

% Objective: minimize transport cost
var int: totalCost = sum(i in H, j in H)(flow[i,j] * cost[i,j]);
solve minimize totalCost;

output [
  "Minimum cost = ", show(totalCost), "\n"
];