include "globals.mzn";

% Input parameters
int: K; % Number of requirements categories
int: I; % Number of different requirements
array[1..K] of int: Strength; % Strength of each requirement category
array[1..K] of float: LessOneWaste; % Cost reduction per unit less waste in each category
array[1..K] of float: MoreOneWaste; % Additional cost per unit more waste in each category
array[1..K] of int: Recruit; % Number of recruits in each category
array[1..K] of int: CostRedundancy; % Cost of redundancy per recruit in each category
int: NumOverman; % Number of over-managed categories allowed
array[1..K] of int: CostOverman; % Cost of over-managing in each category
int: NumShortwork; % Number of short-work categories allowed
array[1..K] of int: CostShort; % Cost of short-work in each category
array[1..K, 1..I] of int: Requirement; % The estimated manpower requirements

% Decision variables
array[1..K, 1..I] of var 0..Recruit[i]: recruit; % Number of recruits in each category
array[1..K, 1..I] of var 0..NumOverman: overman; % Number of over-managed categories
array[1..K, 1..I] of var 0..NumShortwork: shortwork; % Number of short-work categories

% Objective function
var float: total_cost;
constraint total_cost = sum(i in 1..K, j in 1..I) (
    recruit[i,j] * CostRedundancy[i] + 
    overman[i,j] * CostOverman[i] + 
    shortwork[i,j] * CostShort[i] - 
    (Strength[i] - recruit[i,j] - overman[i,j] - shortwork[i,j]) * LessOneWaste[i] +
    (Requirement[i,j] - Strength[i] + recruit[i,j] + overman[i,j] + shortwork[i,j]) * MoreOneWaste[i]
);

% Constraints
constraint forall(i in 1..K, j in 1..I) (
    Strength[i] + recruit[i,j] + overman[i,j] + shortwork[i,j] >= Requirement[i,j]
);

% Minimize total cost
solve minimize total_cost;

% Output
output ["Total cost: ", show(total_cost), "\n"];