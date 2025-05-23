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
array[1..K, 1..I] of var 0..NumOverman: overman; % Number of over-managed categories for each requirement
array[1..K, 1..I] of var 0..NumShortwork: shortwork; % Number of short-work categories for each requirement

% Constraints
constraint forall(k in 1..K, i in 1..I) (
  recruit[k, i] <= Recruit[k] /\ % Recruitment limit
  overman[k, i] <= NumOverman /\ % Over-managing limit
  shortwork[k, i] <= NumShortwork /\ % Short-work limit
  Strength[k] + recruit[k, i] - overman[k, i] - 2*shortwork[k, i] = Requirement[k, i] % Manpower balance
);

% Objective
var float: total_cost = sum(k in 1..K, i in 1..I) (
  recruit[k, i]*CostRedundancy[k] + % Cost of redundancy
  overman[k, i]*CostOverman[k] + % Cost of over-managing
  shortwork[k, i]*CostShort[k] % Cost of short-work
);
solve minimize total_cost;