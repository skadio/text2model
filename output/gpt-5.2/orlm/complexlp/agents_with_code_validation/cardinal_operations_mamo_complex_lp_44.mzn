% Parameters
int: nRegions = 7;
set of int: REGIONS = 1..nRegions;

array[REGIONS] of int: supply =
  [318, 349, 129, 381, 430, 52, 124];

array[REGIONS] of int: demand =
  [309, 9, 279, 71, 365, 233, 483];

% Transport cost per unit from i -> j
array[REGIONS, REGIONS] of int: cost =
  array2d(REGIONS, REGIONS,
  [
    % to:  1   2   3   4   5   6   7
        0,  2, 26, 19, 16, 26, 36,   % from 1
       27,  0, 26,  4, 15, 43, 25,   % from 2
       17, 45,  0, 18, 36, 37, 39,   % from 3
       19, 16, 14,  0,  5, 35,  9,   % from 4
       44, 47,  4,  3,  0,  2,  4,   % from 5
       30, 12, 28, 10, 16,  0, 25,   % from 6
       19, 16, 10,  2, 50,  4,  0    % from 7
  ]);

int: total_supply = sum(i in REGIONS)(supply[i]);
int: total_demand = sum(i in REGIONS)(demand[i]);
int: max_ship = total_supply;

% Variables
array[REGIONS, REGIONS] of var 0..max_ship: ship;

% Constraints
constraint total_supply >= total_demand;

constraint
  forall(i in REGIONS) (
    sum(j in REGIONS)(ship[i, j]) <= supply[i]
  );

constraint
  forall(j in REGIONS) (
    supply[j] + sum(i in REGIONS)(ship[i, j]) - sum(k in REGIONS)(ship[j, k]) >= demand[j]
  );

constraint
  forall(i in REGIONS) (
    ship[i, i] = 0
  );

% Objective
solve minimize sum(i in REGIONS, j in REGIONS)(cost[i, j] * ship[i, j]);