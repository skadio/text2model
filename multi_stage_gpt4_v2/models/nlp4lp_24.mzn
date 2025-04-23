% Parameters
int: K; % Number of requirements categories
int: I; % Number of different requirements
int: NumOverman; % Number of over-managed categories allowed
int: NumShortwork; % Number of short-work categories allowed
array[1..K, 1..I] of int: Requirement; % The estimated manpower requirements of unskilled workers, semi-skilled workers, and skilled workers
array[1..K] of int: Strength; % Strength of each requirement category
array[1..K] of int: LessOneWaste; % Cost reduction per unit less waste in each category
array[1..K] of int: MoreOneWaste; % Additional cost per unit more waste in each category
array[1..K] of int: Recruit; % Number of recruits in each category
array[1..K] of int: CostRedundancy; % Cost of redundancy per recruit in each category
array[1..K] of int: CostOverman; % Cost of over-managing in each category
array[1..K] of int: CostShort; % Cost of short-work in each category

% Variables
var 0..sum(Strength): total_strength; % Total strength of all categories
array[1..K] of var 0..Strength[K]: recruit_strength; % Strength of recruits in each category
array[1..K] of var 0..Strength[K]: redundancy_strength; % Strength of redundant workers in each category
array[1..K] of var 0..Strength[K]: overman_strength; % Strength of over-managed workers in each category
array[1..K] of var 0..Strength[K]: shortwork_strength; % Strength of short-work workers in each category

% Constraints

% The total strength of all categories is the sum of the strength of each category
constraint total_strength = sum(i in 1..K)(Strength[i]);

% The strength of recruits in each category cannot exceed the number of recruits in that category
constraint forall(i in 1..K)(recruit_strength[i] <= Recruit[i]);

% The strength of redundant workers in each category cannot exceed the cost reduction per unit less waste in that category
constraint forall(i in 1..K)(redundancy_strength[i] <= LessOneWaste[i]);

% The strength of over-managed workers in each category cannot exceed the additional cost per unit more waste in that category
constraint forall(i in 1..K)(overman_strength[i] <= MoreOneWaste[i]);

% The total number of over-managed categories cannot exceed the number of over-managed categories allowed
constraint sum(i in 1..K)(overman_strength[i] > 0) <= NumOverman;

% The strength of short-work workers in each category cannot exceed the strength of that category
constraint forall(i in 1..K)(shortwork_strength[i] <= Strength[i]);

% The total strength of all categories must be equal to the sum of the strength of recruits, redundant workers, over-managed workers, and short-work workers in each category
constraint forall(i in 1..K)(total_strength = recruit_strength[i] + redundancy_strength[i] + overman_strength[i] + shortwork_strength[i]);

% The strength of recruits, redundant workers, over-managed workers, and short-work workers in each category must not exceed the strength of that category
constraint forall(i in 1..K)(recruit_strength[i] + redundancy_strength[i] + overman_strength[i] + shortwork_strength[i] <= Strength[i]);

% Objective
solve minimize sum(i in 1..K)(recruit_strength[i]*CostRedundancy[i] - redundancy_strength[i]*LessOneWaste[i] + overman_strength[i]*CostOverman[i] + shortwork_strength[i]*CostShort[i]);