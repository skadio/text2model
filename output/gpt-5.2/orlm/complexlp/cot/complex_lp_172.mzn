% Parameters (with values embedded)
int: M = 8; % potential distribution centers
int: N = 9; % retail stores

set of int: Centers = 1..M;
set of int: Stores  = 1..N;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

array[Stores] of int: demand = [779, 892, 440, 556, 414, 464, 920, 743, 528];

array[Centers] of int: capacity = [1447, 1886, 1962, 1392, 1191, 1218, 1088, 1178];

% Transportation costs are described only as ranges (not per store values),
% so we embed a concrete cost matrix consistent with those ranges.
array[Centers, Stores] of int: transCost =
[
  % stores:   1  2  3  4  5  6  7  8  9
            |2, 3, 4, 5, 2, 3, 4, 5, 2|,  % Center 1 (2..5)
            |1, 2, 3, 4, 5, 1, 2, 3, 4|,  % Center 2 (1..5)
            |1, 2, 3, 4, 1, 2, 3, 4, 1|,  % Center 3 (1..4)
            |1, 2, 3, 4, 5, 1, 2, 3, 4|,  % Center 4 (1..5)
            |1, 3, 5, 2, 4, 1, 3, 5, 2|,  % Center 5 (1..5)
            |2, 4, 1, 3, 5, 2, 4, 1, 3|,  % Center 6 (1..5)
            |2, 3, 4, 5, 2, 3, 4, 5, 2|,  % Center 7 (2..5)
            |1, 2, 3, 4, 5, 1, 2, 3, 4|   % Center 8 (1..5)
];

int: totalDemand = sum(s in Stores)(demand[s]);
int: maxCap = max(c in Centers)(capacity[c]);

% Variables
array[Centers] of var 0..1: open; % whether center is activated
array[Centers, Stores] of var 0..maxCap: ship; % units shipped from center to store

var int: totalOpenCost;
var int: totalTransCost;
var int: totalCost;

% Constraints
constraint
  forall(s in Stores) (
    sum(c in Centers)(ship[c,s]) = demand[s]
  );

constraint
  forall(c in Centers) (
    sum(s in Stores)(ship[c,s]) <= capacity[c] * open[c]
  );

constraint
  totalOpenCost = sum(c in Centers)(openCost[c] * open[c]);

constraint
  totalTransCost = sum(c in Centers, s in Stores)(transCost[c,s] * ship[c,s]);

constraint
  totalCost = totalOpenCost + totalTransCost;

% Objective
solve minimize totalCost;

output [
  "Total cost: ", show(totalCost), "\n",
  "  Open cost: ", show(totalOpenCost), "\n",
  "  Transport cost: ", show(totalTransCost), "\n",
  "Open centers (1=open): ", show(open), "\n"
];