% Facility Location / Capacitated Distribution Planning
% All data embedded as requested.

int: F = 4; % potential distribution centers
int: S = 6; % retail stores

set of int: FAC = 1..F;
set of int: STO = 1..S;

array[FAC] of int: open_cost = [151000, 192000, 114000, 171000];

array[FAC, STO] of int: ship_cost =
[
  % Store:   1  2  3  4  5  6
            5, 5, 2, 3, 3, 3,  % Center 1
            5, 4, 3, 5, 2, 4,  % Center 2
            2, 4, 5, 1, 4, 2,  % Center 3
            5, 4, 1, 1, 3, 3   % Center 4
];

array[STO] of int: demand = [910, 875, 589, 962, 966, 643];
array[FAC] of int: capacity = [1631, 1954, 1446, 820];

int: total_demand = sum(s in STO)(demand[s]);

array[FAC, STO] of var 0..total_demand: x;  % units shipped from facility f to store s
array[FAC] of var bool: open;

% Each store's demand must be met exactly
constraint forall(s in STO)(
  sum(f in FAC)(x[f,s]) = demand[s]
);

% Facility capacity only if opened
constraint forall(f in FAC)(
  sum(s in STO)(x[f,s]) <= capacity[f] * bool2int(open[f])
);

var int: total_open_cost = sum(f in FAC)(open_cost[f] * bool2int(open[f]));
var int: total_ship_cost = sum(f in FAC, s in STO)(ship_cost[f,s] * x[f,s]);
var int: total_cost = total_open_cost + total_ship_cost;

solve minimize total_cost;

output [
  "Total cost = ", show(total_cost), "\n",
  "Open cost  = ", show(total_open_cost), "\n",
  "Ship cost  = ", show(total_ship_cost), "\n\n",
  "Open centers:\n",
  concat([ if fix(open[f]) then "  Center " ++ show(f) ++ "\n" else "" endif | f in FAC ]),
  "\nShipments (x[f,s]):\n",
  concat([
    "Center " ++ show(f) ++ ": " ++
    concat([ " " ++ show(x[f,s]) | s in STO ]) ++ "\n"
    | f in FAC
  ])
];