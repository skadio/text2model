% Parameters
int: K; % Number of different types of resources
array[1..K] of int: Strength; % Strength of each type of resource
array[1..K] of float: LessOneWaste; % Value when wastage of resources is less than optimal
array[1..K] of float: MoreOneWaste; % Value when wastage of resources is more than optimal
array[1..K] of int: Recruit; % Number of recruited resources of each type
array[1..K] of int: CostRedundancy; % Cost of redundancy for each type of resource
int: NumOverman; % Number of overmanned positions
array[1..K] of int: CostOverman; % Cost of overmanning for each type of resource
int: NumShortwork; % Number of shortworked positions
array[1..K] of int: CostShort; % Cost of short working for each type of resource
array[1..3, 1..3] of int: Requirement; % The estimated manpower requirements of unskilled workers, semi-skilled workers, and skilled workers

% Variables
array[1..K] of var 0..Strength[i]: Manpower; % Manpower for each type of resource
array[1..K] of var 0..Recruit[i]: Recruits; % Number of recruits for each type of resource
array[1..K] of var 0..NumOverman: Overman; % Number of overmanned positions for each type of resource
array[1..K] of var 0..NumShortwork: Shortwork; % Number of shortworked positions for each type of resource

% Constraints
constraint forall(i in 1..K) (
  Manpower[i] = Strength[i] - LessOneWaste[i]*Strength[i] - MoreOneWaste[i]*Strength[i] + Recruits[i] - Overman[i] - 0.5*Shortwork[i]
);
constraint forall(i in 1..K) (
  Manpower[i] >= Requirement[i,1] + Requirement[i,2] + Requirement[i,3]
);

% Objective
var int: TotalCost = sum(i in 1..K) (CostRedundancy[i]*Overman[i] + CostOverman[i]*Overman[i] + CostShort[i]*Shortwork[i]);
solve minimize TotalCost;

% Output
output ["Total Cost: ", show(TotalCost), "\n"] ++
["Manpower: ", show(Manpower), "\n"] ++
["Recruits: ", show(Recruits), "\n"] ++
["Overman: ", show(Overman), "\n"] ++
["Shortwork: ", show(Shortwork), "\n"];