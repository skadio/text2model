% Facility location / transportation model (all data embedded)

% Parameters
int: M = 8; % distribution centers
int: N = 8; % retail stores

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

% Transportation cost per unit from DC i to store j
array[DC, ST] of int: transCost = array2d(DC, ST,
[
  3, 5, 6, 2, 3, 6, 6, 4,
  2, 4, 2, 4, 2, 3, 3, 4,
  4, 4, 5, 4, 4, 2, 4, 5,
  4, 2, 3, 5, 5, 3, 4, 4,
  4, 5, 4, 5, 5, 2, 4, 5,
  4, 5, 3, 4, 4, 4, 3, 3,
  4, 4, 4, 5, 4, 2, 3, 2,
  4, 3, 2, 3, 2, 4, 4, 4
]);

array[ST] of int: demand = [695, 785, 535, 200, 250, 750, 645, 440];
array[DC] of int: capacity = [1980, 1190, 1350, 1640, 1590, 1440, 1710, 1962];

int: totalDemand = sum(j in ST)(demand[j]);

% Variables
array[DC] of var bool: open;
array[DC, ST] of var 0..totalDemand: ship;

var int: totalCost =
    sum(i in DC)(openCost[i] * bool2int(open[i])) +
    sum(i in DC, j in ST)(transCost[i,j] * ship[i,j]);

% Constraints
constraint
  forall(j in ST) (
    sum(i in DC)(ship[i,j]) = demand[j]
  );

constraint
  forall(i in DC) (
    sum(j in ST)(ship[i,j]) <= capacity[i] * bool2int(open[i])
  );

% Objective type requested: maximization
% (Maximizing negative cost is equivalent to minimizing cost.)
solve maximize (-totalCost);

output [
  "totalCost = ", show(totalCost), "\n",
  "open = ", show(open), "\n"
];