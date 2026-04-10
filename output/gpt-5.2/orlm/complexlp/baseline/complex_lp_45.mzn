% Medical supplies redistribution among clinics (transportation problem)
% All data embedded as requested.

int: N = 4;
set of int: CLINICS = 1..N;

array[CLINICS] of int: stock = [330, 294, 474, 86];
array[CLINICS] of int: need  = [476,  92, 385, 203];

% Cost matrix (cost[i,j] is cost to ship 1 unit from i to j)
% Diagonal set to 0 (no self-shipment needed)
array[CLINICS, CLINICS] of int: cost =
  [|  0,  2, 12, 19
   | 28,  0,  9, 10
   | 23, 46,  0,  7
   | 19, 16, 23,  0 |];

% Decision variables: shipped units from clinic i to clinic j
array[CLINICS, CLINICS] of var 0..sum(stock): x;

% No self shipments
constraint forall(i in CLINICS)( x[i,i] = 0 );

% Flow balance at each clinic:
% final stock = stock + inflow - outflow
% Must meet or exceed need
constraint forall(k in CLINICS)(
  stock[k] + sum(i in CLINICS)(x[i,k]) - sum(j in CLINICS)(x[k,j]) >= need[k]
);

% Cannot ship out more than available initial stock
constraint forall(i in CLINICS)(
  sum(j in CLINICS)(x[i,j]) <= stock[i]
);

var int: total_cost = sum(i,j in CLINICS)( cost[i,j] * x[i,j] );

solve minimize total_cost;

output [
  "Minimum cost = ", show(total_cost), "\n",
  "Shipments x[i,j] (units):\n"
] ++
[
  if j = 1 then "From clinic " ++ show(i) ++ ": " else "" endif ++
  show(x[i,j]) ++ (if j = N then "\n" else " " endif)
  | i in CLINICS, j in CLINICS
];