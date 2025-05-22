include "globals.mzn";

% Parameters
int: num_skis;
int: num_skiers;

set of int: SKIS   = 1..num_skis;
set of int: SKIERS = 1..num_skiers;

array[SKIS]   of int: ski_heights;
array[SKIERS] of int: skier_heights;

% Derived constants
int: max_ski_height   = max(i in SKIS)(ski_heights[i]);
int: min_ski_height   = min(i in SKIS)(ski_heights[i]);
int: max_skier_height = max(j in SKIERS)(skier_heights[j]);
int: min_skier_height = min(j in SKIERS)(skier_heights[j]);

int: MAX_ABS_DIFF = max(max_ski_height, max_skier_height) - min(min_ski_height, min_skier_height);

% Variables
array[SKIERS] of var SKIS: assign;                 % ski chosen for each skier
array[SKIERS] of var 0..MAX_ABS_DIFF: diff;        % absolute disparity for each skier

% Constraints
constraint num_skis >= num_skiers;                 % feasibility check
constraint all_different(assign);                  % each ski used at most once
constraint forall(s in SKIERS)(
    diff[s] = abs(ski_heights[assign[s]] - skier_heights[s])
);

% Objective
solve minimize sum(s in SKIERS)(diff[s]);