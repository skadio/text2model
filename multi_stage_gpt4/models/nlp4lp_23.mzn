% Parameters
int: K; % Total number of different types of resources
int: I; % Number of different requirements for each type of resource
array[1..K] of int: Strength; % Strength of each type of resource
array[1..K] of int: LessOneWaste; % Value when wastage of resources is less than optimal
array[1..K] of int: MoreOneWaste; % Value when wastage of resources is more than optimal
array[1..K] of int: Recruit; % Number of recruited resources of each type
array[1..K] of int: CostRedundancy; % Cost of redundancy for each type of resource
int: NumOverman; % Number of overmanned positions
array[1..K] of int: CostOverman; % Cost of overmanning for each type of resource
int: NumShortwork; % Number of shortworked positions
array[1..K] of int: CostShort; % Cost of short working for each type of resource
array[1..K, 1..I] of int: Requirement; % The estimated manpower requirements of unskilled workers, semi-skilled workers, and skilled workers

% Variables
var 0..sum(Requirement): totalRedundancy; % Total redundancy across all types of resources
array[1..K, 1..I] of var 0..sum(Requirement): manpower; % Manpower for each type of resource and each requirement
array[1..K, 1..I] of var 0..sum(Requirement): redundancy; % Redundancy for each type of resource and each requirement
array[1..K, 1..I] of var 0..sum(Requirement): overman; % Overmanning for each type of resource and each requirement
array[1..K, 1..I] of var 0..sum(Requirement): shortwork; % Short working for each type of resource and each requirement

% Constraints

% Constraint 1: The manpower for each type of resource and each requirement should be less than or equal to the strength of the resource
forall(k in 1..K, i in 1..I) (
    manpower[k, i] <= Strength[k]
);

% Constraint 2: The redundancy for each type of resource and each requirement should be less than or equal to the manpower of the resource
forall(k in 1..K, i in 1..I) (
    redundancy[k, i] <= manpower[k, i]
);

% Constraint 3: The overmanning for each type of resource and each requirement should be less than or equal to the number of overmanned positions
forall(k in 1..K, i in 1..I) (
    overman[k, i] <= NumOverman
);

% Constraint 4: The short working for each type of resource and each requirement should be less than or equal to the number of shortworked positions
forall(k in 1..K, i in 1..I) (
    shortwork[k, i] <= NumShortwork
);

% Constraint 5: The total redundancy across all types of resources should be less than or equal to the sum of the redundancy for each type of resource and each requirement
constraint totalRedundancy = sum(k in 1..K, i in 1..I) (redundancy[k, i]);

% Constraint 6: The manpower for each type of resource and each requirement should be greater than or equal to the requirement of the resource
forall(k in 1..K, i in 1..I) (
    manpower[k, i] >= Requirement[k, i]
);

% Constraint 7: The manpower for each type of resource and each requirement should be less than or equal to the sum of the strength of the resource, the number of recruited resources, and the number of overmanned positions
forall(k in 1..K, i in 1..I) (
    manpower[k, i] <= Strength[k] + Recruit[k] + overman[k, i]
);

% Constraint 8: The manpower for each type of resource and each requirement should be greater than or equal to the sum of the requirement of the resource and the number of shortworked positions
forall(k in 1..K, i in 1..I) (
    manpower[k, i] >= Requirement[k, i] + shortwork[k, i]
);

% Objective
solve minimize totalRedundancy;