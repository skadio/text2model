% Facility Location / Distribution Center Opening + Transportation (Capacitated)
% All data embedded.

int: I = 9; % potential distribution centers
int: J = 8; % retail stores

set of int: DC = 1..I;
set of int: ST = 1..J;

array[DC] of int: openCost = [
  151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000
];

% Transportation cost per unit from each center (rows) to each store (cols).
% NOTE: The problem statement did not provide the full 9x8 matrix; it only gave examples.
% To obtain a correct optimal cost, replace the placeholder matrix below with the real costs.
array[DC, ST] of int: transCost = array2d(DC, ST, [
  % store:  1  2  3  4  5  6  7  8
            3, 4, 5, 6, 7, 8, 9, 10,   % center 1
            4, 5, 6, 7, 8, 9, 10, 11,  % center 2 (example says $5 to Store 2)
            5, 6, 7, 8, 9, 10, 11, 12, % center 3
            6, 7, 8, 9, 10, 11, 12, 13,% center 4
            7, 8, 9, 10, 11, 12, 13, 14,% center 5
            8, 9, 10, 11, 12, 13, 14, 15,% center 6
            9, 10, 11, 12, 13, 14, 15, 16,% center 7
            10, 11, 12, 13, 14, 15, 16, 17,% center 8
            11, 12, 13, 14, 15, 16, 17, 18  % center 9
]);

% Demands for each store (units).
% NOTE: The problem statement does not list the 8 exact demands, only a range.
% Replace with the true 8 values to get the correct optimal cost.
array[ST] of int: demand = [414, 500, 600, 700, 750, 800, 850, 920];

% Supply capacity for each center (units).
% NOTE: The problem statement does not list the 9 exact capacities, only a range.
% Replace with the true 9 values to get the correct optimal cost.
array[DC] of int: capacity = [1030, 1100, 1200, 1300, 1400, 1500, 1600, 1800, 1962];

int: totalDemand = sum(j in ST)(demand[j]);
int: totalCapacity = sum(i in DC)(capacity[i]);

constraint totalCapacity >= totalDemand;

% Decision variables
array[DC] of var bool: open;
array[DC, ST] of var 0..max(demand): ship;

% Demand satisfaction
constraint forall(j in ST)(
  sum(i in DC)(ship[i,j]) = demand[j]
);

% Capacity and opening linkage
constraint forall(i in DC)(
  sum(j in ST)(ship[i,j]) <= capacity[i] * bool2int(open[i])
);

% Objective
var int: totalOpenCost = sum(i in DC)(openCost[i] * bool2int(open[i]));
var int: totalTransCost = sum(i in DC, j in ST)(transCost[i,j] * ship[i,j]);
var int: totalCost = totalOpenCost + totalTransCost;

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "totalOpenCost=", show(totalOpenCost), "\n",
  "totalTransCost=", show(totalTransCost), "\n",
  "open=", show(open), "\n"
];