% Parameters
int: NumOverman; % Number of over-managed categories allowed
int: NumShortwork; % Number of short-work categories allowed
array[1..3] of int: Strength; % Strength of each requirement category
array[1..3] of int: Recruit; % Number of recruits in each category
array[1..3] of int: CostRedundancy; % Cost of redundancy per recruit in each category
array[1..3] of int: CostOverman; % Cost of over-managing in each category
array[1..3] of int: CostShort; % Cost of short-work in each category
array[1..3, 1..3] of int: Requirement; % The estimated manpower requirements of unskilled workers, semi-skilled workers, and skilled workers

% Variables
array[1..3, 1..3] of var 0..max(Recruit): recruit; % Number of recruits in each category for each requirement
array[1..3, 1..3] of var 0..NumOverman: overman; % Number of over-managed categories for each requirement
array[1..3, 1..3] of var 0..NumShortwork: shortwork; % Number of short-work categories for each requirement

% Constraints
constraint forall(k in 1..3, i in 1..3) (
  Strength[k] + recruit[k,i] - overman[k,i] - 2*shortwork[k,i] >= Requirement[k,i]
);
constraint sum(k in 1..3, i in 1..3) (recruit[k,i]) <= sum(Recruit);
constraint sum(k in 1..3, i in 1..3) (overman[k,i]) <= NumOverman;
constraint sum(k in 1..3, i in 1..3) (shortwork[k,i]) <= NumShortwork;

% Objective
var float: total_cost;
constraint total_cost = sum(k in 1..3, i in 1..3) (
  recruit[k,i]*CostRedundancy[k] + overman[k,i]*CostOverman[k] + shortwork[k,i]*CostShort[k]
);
solve minimize total_cost;