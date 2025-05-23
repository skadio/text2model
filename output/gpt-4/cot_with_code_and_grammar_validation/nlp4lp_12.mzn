% Parameters
int: K; % Number of requirements categories
int: I; % Number of different requirements
int: NumOverman; % Number of over-managed categories allowed
int: NumShortwork; % Number of short-work categories allowed
array[1..K] of int: Strength; % Strength of each requirement category
array[1..K] of float: LessOneWaste; % Cost reduction per unit less waste in each category
array[1..K] of float: MoreOneWaste; % Additional cost per unit more waste in each category
array[1..K] of int: Recruit; % Number of recruits in each category
array[1..K] of int: CostRedundancy; % Cost of redundancy per recruit in each category
array[1..K] of int: CostOverman; % Cost of over-managing in each category
array[1..K] of int: CostShort; % Cost of short-work in each category
array[1..K, 1..I] of int: Requirement; % The estimated manpower requirements of unskilled workers, semi-skilled workers, and skilled workers

% Variables
array[1..K, 1..I] of var 0..max(Recruit): recruit; % Number of recruits in each category for each requirement
array[1..K, 1..I] of var 0..max(Strength): strength; % Strength of each requirement category for each requirement
array[1..K, 1..I] of var 0..NumOverman: overman; % Number of over-managed categories for each requirement
array[1..K, 1..I] of var 0..NumShortwork: shortwork; % Number of short-work categories for each requirement

% Constraints
constraint forall(k in 1..K, i in 1..I) (
  strength[k, i] = if i = 1 then Strength[k] else strength[k, i-1] - recruit[k, i-1] + overman[k, i-1] - shortwork[k, i-1] endif
);
constraint forall(k in 1..K, i in 1..I) (
  recruit[k, i] <= Recruit[k]
);
constraint forall(k in 1..K, i in 1..I) (
  overman[k, i] <= NumOverman
);
constraint forall(k in 1..K, i in 1..I) (
  shortwork[k, i] <= NumShortwork
);
constraint forall(k in 1..K, i in 1..I) (
  strength[k, i] + recruit[k, i] - overman[k, i] + shortwork[k, i] = Requirement[k, i]
);

% Objective
var float: total_cost;
constraint total_cost = sum(k in 1..K, i in 1..I) (
  recruit[k, i] * CostRedundancy[k] + overman[k, i] * CostOverman[k] + shortwork[k, i] * CostShort[k]
  - strength[k, i] * LessOneWaste[k] + strength[k, i] * MoreOneWaste[k]
);
solve minimize total_cost;