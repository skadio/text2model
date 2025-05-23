% Parameters
int: K; % Number of requirements categories
int: I; % Number of different requirements
array[1..K, 1..I] of int: Requirement; % The estimated manpower requirements of unskilled workers, semi-skilled workers, and skilled workers
array[1..K] of int: Strength; % Strength of each requirement category
array[1..K] of int: LessOneWaste; % Cost reduction per unit less waste in each category
array[1..K] of int: MoreOneWaste; % Additional cost per unit more waste in each category
array[1..K] of int: Recruit; % Number of recruits in each category
array[1..K] of int: CostRedundancy; % Cost of redundancy per recruit in each category
int: NumOverman; % Number of over-managed categories allowed
array[1..K] of int: CostOverman; % Cost of over-managing in each category
int: NumShortwork; % Number of short-work categories allowed
array[1..K] of int: CostShort; % Cost of short-work in each category

% Variables
array[1..K, 1..I] of var 0..max(Strength): manpower; % Manpower in each category for each requirement
array[1..K] of var 0..max(Recruit): recruits; % Number of recruits in each category
array[1..K] of var 0..NumOverman: overman; % Number of over-managed categories
array[1..K] of var 0..NumShortwork: shortwork; % Number of short-work categories

% Constraints

% The manpower in each category for each requirement should be less than or equal to the strength of each requirement category
constraint forall(k in 1..K, i in 1..I) (
  manpower[k, i] <= Strength[k]
);

% The number of recruits in each category should be less than or equal to the number of recruits available
constraint forall(k in 1..K) (
  recruits[k] <= Recruit[k]
);

% The number of over-managed categories should be less than or equal to the number of over-managed categories allowed
constraint forall(k in 1..K) (
  overman[k] <= NumOverman
);

% The number of short-work categories should be less than or equal to the number of short-work categories allowed
constraint forall(k in 1..K) (
  shortwork[k] <= NumShortwork
);

% The manpower in each category for each requirement should be greater than or equal to the estimated manpower requirements
constraint forall(k in 1..K, i in 1..I) (
  manpower[k, i] >= Requirement[k, i]
);

% The manpower in each category for each requirement should be less than or equal to the strength of each requirement category plus the number of recruits in each category
constraint forall(k in 1..K, i in 1..I) (
  manpower[k, i] <= Strength[k] + recruits[k]
);

% The manpower in each category for each requirement should be less than or equal to the strength of each requirement category plus the number of recruits in each category minus the number of over-managed categories
constraint forall(k in 1..K, i in 1..I) (
  manpower[k, i] <= Strength[k] + recruits[k] - overman[k]
);

% The manpower in each category for each requirement should be greater than or equal to the estimated manpower requirements minus the number of short-work categories
constraint forall(k in 1..K, i in 1..I) (
  manpower[k, i] >= Requirement[k, i] - shortwork[k]
);

% Objective
solve minimize sum(k in 1..K, i in 1..I) (
  (manpower[k, i] - Requirement[k, i]) * LessOneWaste[k] +
  (Requirement[k, i] - manpower[k, i]) * MoreOneWaste[k] +
  recruits[k] * CostRedundancy[k] +
  overman[k] * CostOverman[k] +
  shortwork[k] * CostShort[k]
);