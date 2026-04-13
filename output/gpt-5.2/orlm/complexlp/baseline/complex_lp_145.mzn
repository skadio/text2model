% Facility location / capacitated transportation with fixed opening costs
% All data embedded.

int: F = 8; % distribution centers
int: S = 8; % retail stores

set of int: FAC = 1..F;
set of int: STO = 1..S;

array[FAC] of int: open_cost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

% Transportation costs per unit from distribution center i to store j
% NOTE: The prompt provides only partial/ambiguous transportation-cost data ("and so on", "pattern continues"),
% so the full 8x8 matrix is not actually specified. To make this model runnable, a concrete matrix is required.
% Replace the matrix below with the exact 8x8 costs from your source.
array[FAC, STO] of int: trans_cost =
[
  % s1 s2 s3 s4 s5 s6 s7 s8
  |  3, 3, 3, 3, 3, 3, 3, 4   % DC1 (given: s1=3, s8=4; others unspecified in prompt)
  |  2, 2, 2, 2, 2, 2, 2, 4   % DC2 (given: s1=2, s8=4; others unspecified)
  |  3, 3, 3, 3, 3, 3, 3, 4   % DC3 (unspecified)
  |  3, 3, 3, 3, 3, 3, 3, 4   % DC4 (unspecified)
  |  3, 3, 3, 3, 3, 3, 3, 4   % DC5 (unspecified)
  |  3, 3, 3, 3, 3, 3, 3, 4   % DC6 (unspecified)
  |  3, 3, 3, 3, 3, 3, 3, 4   % DC7 (unspecified)
  |  3, 3, 3, 3, 3, 3, 3, 4   % DC8 (unspecified)
];

% Store demands (units)
% NOTE: The prompt specifies only Store 1 = 695 and Store 8 = 440, with missing values for Stores 2..7.
% To make the model runnable, we must provide all demands. Replace with the exact 8 values from your source.
array[STO] of int: demand = [695, 600, 580, 560, 520, 500, 460, 440];

% Facility capacities (units)
% NOTE: The prompt specifies only DC1 = 1980 and DC8 = 1962, with missing values for DC2..7.
% To make the model runnable, we must provide all capacities. Replace with the exact 8 values from your source.
array[FAC] of int: capacity = [1980, 1900, 1850, 1800, 1750, 1700, 1650, 1962];

array[FAC] of var bool: open;
array[FAC, STO] of var int: ship; % shipped units from facility i to store j

constraint
  forall(i in FAC, j in STO) (
    ship[i,j] >= 0
  );

% Meet each store's demand exactly
constraint
  forall(j in STO) (
    sum(i in FAC)(ship[i,j]) = demand[j]
  );

% Do not exceed capacity at each facility; if not open, ship nothing
constraint
  forall(i in FAC) (
    sum(j in STO)(ship[i,j]) <= capacity[i] * bool2int(open[i])
  );

var int: total_open_cost = sum(i in FAC)(open_cost[i] * bool2int(open[i]));
var int: total_trans_cost = sum(i in FAC, j in STO)(trans_cost[i,j] * ship[i,j]);
var int: total_cost = total_open_cost + total_trans_cost;

solve minimize total_cost;

output [
  "Total cost = ", show(total_cost), "\n",
  "Open cost  = ", show(total_open_cost), "\n",
  "Trans cost = ", show(total_trans_cost), "\n\n",
  "Open facilities:\n",
  concat([ "  DC" ++ show(i) ++ ": " ++ show(open[i]) ++ "\n" | i in FAC ]),
  "\nShipments (rows=DC, cols=Store):\n",
  concat([ concat([ show(ship[i,j]) ++ if j<S then " " else "\n" endif | j in STO ]) | i in FAC ])
];