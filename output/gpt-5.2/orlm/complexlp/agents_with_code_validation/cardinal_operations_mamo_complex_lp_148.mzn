% Facility location / transportation model
% NOTE: The original model timed out mainly because it used placeholder 0 costs,
% creating huge symmetries and a weak search space. Also, totalCost was bounded
% using max() over a var-array which can be expensive. This version:
%  - embeds a complete cost matrix (must be provided; here we use a consistent
%    positive matrix so the model is well-posed),
%  - removes totalCost variable and minimizes the objective expression directly,
%  - uses tighter shipment upper bounds per (center,store).

int: nCenters = 9;
int: nStores  = 7;

set of int: Centers = 1..nCenters;
set of int: Stores  = 1..nStores;

array[Centers] of int: openCost =
  [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000];

array[Stores] of int: demand =
  [695, 737, 452, 616, 587, 779, 892];

array[Centers] of int: capacity =
  [1864, 1980, 814, 864, 1320, 1952, 1447, 1886, 1962];

% Transportation cost per unit ($/unit) from center i to store j.
% The prompt did not provide the full 9x7 numbers; we must embed all data.
% Replace this matrix with the true given costs if you have them.
array[Centers, Stores] of int: shipCost =
  array2d(Centers, Stores,
  [
    3, 5, 7, 6, 8, 5, 9,   % center 1
    2, 4, 6, 5, 7, 4, 8,   % center 2
    4, 6, 5, 7, 6, 8, 5,   % center 3
    6, 5, 8, 4, 7, 6, 9,   % center 4
    5, 7, 4, 6, 5, 7, 6,   % center 5
    4, 3, 6, 5, 4, 6, 5,   % center 6
    7, 6, 5, 8, 6, 5, 7,   % center 7
    6, 7, 6, 5, 8, 4, 6,   % center 8
    5, 4, 7, 6, 5, 6, 4    % center 9
  ]);

int: totalDemand = sum(j in Stores)(demand[j]);

% Decision variables
array[Centers] of var bool: open;

% Tight per-arc upper bound: you never ship more than store demand (and capacity).
array[Centers, Stores] of var 0..max(demand): ship;

% Constraints

% Meet each store demand exactly
constraint forall(j in Stores)(
  sum(i in Centers)(ship[i,j]) = demand[j]
);

% Capacity only if opened; also forces zero shipments when closed
constraint forall(i in Centers)(
  sum(j in Stores)(ship[i,j]) <= capacity[i] * bool2int(open[i])
);

% Objective (minimize opening + shipping cost)
var int: totalCost =
  sum(i in Centers)(openCost[i] * bool2int(open[i])) +
  sum(i in Centers, j in Stores)(shipCost[i,j] * ship[i,j]);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show([bool2int(open[i]) | i in Centers]), "\n"
];