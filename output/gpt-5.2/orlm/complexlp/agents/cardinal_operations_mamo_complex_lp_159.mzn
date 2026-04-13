% Parameters
int: nCenters = 9;                      % Number of potential distribution centers
int: nStores  = 9;                      % Number of retail stores

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost =       % Fixed opening cost for each center
  [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000];

array[STORES] of int: demand =          % Demand of each store
  [871, 462, 538, 898, 992, 791, 818, 688, 778];

array[CENTERS] of int: capacity =       % Supply capacity of each center
  [840, 980, 1100, 1250, 1300, 1400, 1500, 1700, 1856];

array[CENTERS, STORES] of int: transCost =  % Transport cost per unit (1..5)
[
  % s1 s2 s3 s4 s5 s6 s7 s8 s9
   2, 3, 4, 5, 2, 3, 4, 2, 1,   % center 1
   3, 2, 5, 4, 3, 1, 2, 5, 4,   % center 2
   1, 4, 2, 3, 5, 2, 3, 4, 2,   % center 3
   5, 3, 1, 2, 4, 5, 2, 3, 1,   % center 4
   2, 5, 3, 1, 2, 4, 5, 1, 3,   % center 5
   4, 1, 2, 5, 3, 2, 1, 4, 5,   % center 6
   3, 2, 4, 1, 5, 3, 2, 5, 4,   % center 7
   2, 5, 1, 4, 2, 5, 3, 2, 1,   % center 8
   5, 4, 3, 2, 1, 4, 5, 3, 2    % center 9
];

int: totalDemand = sum(s in STORES)(demand[s]);  % Upper bound for shipped units overall

% Variables
array[CENTERS] of var 0..1: open;  % 1 if center is opened, else 0

array[CENTERS, STORES] of var 0..totalDemand: ship; % Units shipped from center c to store s

% Constraints
% Demand satisfaction: each store's demand must be met exactly
constraint
  forall(s in STORES) (
    sum(c in CENTERS)(ship[c, s]) = demand[s]
  );

% Capacity and opening linkage: shipments out of a center cannot exceed its capacity unless opened
constraint
  forall(c in CENTERS) (
    sum(s in STORES)(ship[c, s]) <= capacity[c] * open[c]
  );

% Objective
solve minimize
  sum(c in CENTERS)(openCost[c] * open[c]) +
  sum(c in CENTERS, s in STORES)(transCost[c, s] * ship[c, s]);