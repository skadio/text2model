% Facility location + capacitated transportation (fixed-charge) model
% All data embedded.

int: F = 8;   % potential distribution centers
int: S = 9;   % retail stores

set of int: FAC = 1..F;
set of int: STO = 1..S;

array[FAC] of int: open_cost = [
  151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000
];

array[STO] of int: demand = [
  779, 892, 440, 556, 414, 464, 920, 743, 528
];

array[FAC] of int: capacity = [
  1447, 1886, 1962, 1392, 1191, 1218, 1088, 1178
];

% The statement does not provide the full 8x9 transportation cost matrix,
% only cost ranges. To make the model well-defined, we embed a concrete
% cost matrix consistent with the described ranges (1..5, with centers 1 & 7 in 2..5).
array[FAC, STO] of int: ship_cost =
[
  % stores:   1  2  3  4  5  6  7  8  9
            |2, 3, 4, 5, 2, 3, 4, 5, 2|,  % center 1 (2..5)
            |1, 2, 3, 4, 5, 1, 2, 3, 4|,  % center 2 (1..5)
            |1, 1, 2, 3, 4, 2, 3, 4, 1|,  % center 3 (1..4)
            |2, 1, 3, 2, 4, 5, 1, 3, 2|,  % center 4 (1..5)
            |3, 2, 1, 4, 2, 3, 5, 1, 4|,  % center 5 (1..5)
            |4, 3, 2, 1, 3, 2, 4, 5, 1|,  % center 6 (1..5)
            |5, 4, 3, 2, 5, 4, 3, 2, 5|,  % center 7 (2..5)
            |1, 2, 4, 5, 1, 2, 3, 4, 5|   % center 8 (1..5)
];

% Decision variables
array[FAC] of var bool: open;
array[FAC, STO] of var int: x; % units shipped from facility f to store s

% Bounds
constraint forall(f in FAC, s in STO) (x[f,s] >= 0);

% Demand satisfaction
constraint forall(s in STO)(
  sum(f in FAC)(x[f,s]) = demand[s]
);

% Capacity and linking to open/close
constraint forall(f in FAC)(
  sum(s in STO)(x[f,s]) <= capacity[f] * bool2int(open[f])
);

% Objective: fixed opening + variable shipping
var int: total_cost =
  sum(f in FAC)(open_cost[f] * bool2int(open[f])) +
  sum(f in FAC, s in STO)(ship_cost[f,s] * x[f,s]);

solve minimize total_cost;

output [
  "Total cost = ", show(total_cost), "\n",
  "Open centers: ", show([bool2int(open[f]) | f in FAC]), "\n",
  "Shipments (rows=centers, cols=stores):\n",
  concat([ concat([ show(x[f,s]) ++ if s==S then "\n" else "\t" endif
                  | s in STO ])
         | f in FAC ])
];