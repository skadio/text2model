% Facility location / transportation with fixed opening costs
% Data is embedded as requested.

% Parameters
int: nDC = 8;
int: nStore = 8;

set of int: DC = 1..nDC;
set of int: Store = 1..nStore;

array[DC] of int: openCost = [
  151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000
];

array[DC, Store] of int: transCost =
array2d(DC, Store, [
  % DC1
  3, 3, 3, 4, 2, 4, 3, 4,
  % DC2
  2, 3, 5, 4, 3, 3, 4, 4,
  % DC3
  3, 2, 4, 4, 3, 5, 3, 3,
  % DC4
  4, 3, 3, 3, 4, 4, 2, 5,
  % DC5
  3, 4, 2, 3, 3, 4, 4, 3,
  % DC6
  2, 3, 3, 2, 4, 3, 5, 4,
  % DC7
  4, 4, 3, 4, 2, 3, 3, 4,
  % DC8
  3, 2, 4, 3, 4, 4, 3, 4
]);

array[Store] of int: demand = [
  695, 782, 631, 489, 701, 520, 618, 440
];

array[DC] of int: capacity = [
  1980, 2010, 1895, 2050, 1930, 1975, 1990, 1962
];

int: totalDemand = sum(s in Store)(demand[s]);

% Variables
array[DC] of var bool: open;
array[DC, Store] of var 0..totalDemand: ship;

var int: totalCost;

% Constraints

% Demand satisfaction
constraint forall(s in Store)(
  sum(i in DC)(ship[i,s]) = demand[s]
);

% Capacity only if opened
constraint forall(i in DC)(
  sum(s in Store)(ship[i,s]) <= capacity[i] * bool2int(open[i])
);

% Total cost definition
constraint
  totalCost =
    sum(i in DC)(openCost[i] * bool2int(open[i])) +
    sum(i in DC, s in Store)(transCost[i,s] * ship[i,s]);

% Objective type requested: maximization
solve maximize totalCost;