include "globals.mzn";

% Input parameters
int: K; % Total number of different types of resources
int: I; % Number of different requirements for each type of resource
array[1..K] of int: Strength; % Strength of each type of resource
array[1..K] of float: LessOneWaste; % Value when wastage of resources is less than optimal
array[1..K] of float: MoreOneWaste; % Value when wastage of resources is more than optimal
array[1..K] of int: Recruit; % Number of recruited resources of each type
array[1..K] of int: CostRedundancy; % Cost of redundancy for each type of resource
int: NumOverman; % Number of overmanned positions
array[1..K] of int: CostOverman; % Cost of overmanning for each type of resource
int: NumShortwork; % Number of shortworked positions
array[1..K] of int: CostShort; % Cost of short working for each type of resource
array[1..K, 1..I] of int: Requirement; % The estimated manpower requirements of unskilled workers, semi-skilled workers, and skilled workers

% Decision variables
array[1..K, 1..I] of var 0..Strength[_]: Manpower;
array[1..K, 1..I] of var 0..Recruit[_]: Recruits;
array[1..K, 1..I] of var 0..NumOverman: Overman;
array[1..K, 1..I] of var 0..NumShortwork: Shortwork;

% Objective
var int: RedundancyCost = sum(k in 1..K)(CostRedundancy[k] * sum(i in 1..I)(Manpower[k,i] - Requirement[k,i]));
solve minimize RedundancyCost;

% Constraints
constraint forall(k in 1..K, i in 1..I)(
  Manpower[k,i] = Strength[k] - LessOneWaste[k]*Strength[k] + Recruits[k,i] - MoreOneWaste[k]*Recruits[k,i] + Overman[k,i] - Shortwork[k,i]
);
constraint forall(k in 1..K)(
  sum(i in 1..I)(Overman[k,i]) <= NumOverman
);
constraint forall(k in 1..K)(
  sum(i in 1..I)(Shortwork[k,i]) <= NumShortwork
);
constraint forall(k in 1..K, i in 1..I)(
  Manpower[k,i] >= Requirement[k,i]
);