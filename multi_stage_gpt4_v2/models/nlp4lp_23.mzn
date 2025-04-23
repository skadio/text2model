% Parameters
int: K; % Total number of different types of resources
int: I; % Number of different requirements for each type of resource
array[1..K, 1..I] of int: Requirement; % The estimated manpower requirements of unskilled workers, semi-skilled workers, and skilled workers
array[1..K] of int: Strength; % Strength of each type of resource
array[1..K] of int: LessOneWaste; % Value when wastage of resources is less than optimal
array[1..K] of int: MoreOneWaste; % Value when wastage of resources is more than optimal
array[1..K] of int: Recruit; % Number of recruited resources of each type
array[1..K] of int: CostRedundancy; % Cost of redundancy for each type of resource
int: NumOverman; % Number of overmanned positions
array[1..K] of int: CostOverman; % Cost of overmanning for each type of resource
int: NumShortwork; % Number of shortworked positions
array[1..K] of int: CostShort; % Cost of short working for each type of resource

% Variables
var 0..sum(Requirement): totalRequirement; % Total requirement for all types of resources
var 0..sum(Strength): totalStrength; % Total strength of all types of resources
var 0..sum(LessOneWaste): totalLessOneWaste; % Total wastage when less than optimal
var 0..sum(MoreOneWaste): totalMoreOneWaste; % Total wastage when more than optimal
var 0..sum(Recruit): totalRecruit; % Total number of recruited resources
var 0..sum(CostRedundancy): totalCostRedundancy; % Total cost of redundancy
var 0..NumOverman: totalNumOverman; % Total number of overmanned positions
var 0..sum(CostOverman): totalCostOverman; % Total cost of overmanning
var 0..NumShortwork: totalNumShortwork; % Total number of shortworked positions
var 0..sum(CostShort): totalCostShort; % Total cost of short working

% Constraints

% Total requirement for all types of resources
constraint totalRequirement = sum(i in 1..K, j in 1..I)(Requirement[i,j]);

% Total strength of all types of resources
constraint totalStrength = sum(i in 1..K)(Strength[i]);

% Total wastage when less than optimal
constraint totalLessOneWaste = sum(i in 1..K)(LessOneWaste[i]);

% Total wastage when more than optimal
constraint totalMoreOneWaste = sum(i in 1..K)(MoreOneWaste[i]);

% Total number of recruited resources
constraint totalRecruit = sum(i in 1..K)(Recruit[i]);

% Total cost of redundancy
constraint totalCostRedundancy = sum(i in 1..K)(CostRedundancy[i]);

% Total number of overmanned positions
constraint totalNumOverman <= NumOverman;

% Total cost of overmanning
constraint totalCostOverman = sum(i in 1..K)(CostOverman[i]);

% Total number of shortworked positions
constraint totalNumShortwork <= NumShortwork;

% Total cost of short working
constraint totalCostShort = sum(i in 1..K)(CostShort[i]);

% The total strength of all types of resources should be greater than or equal to the total requirement
constraint totalStrength >= totalRequirement;

% The total number of recruited resources should be less than or equal to the total strength of all types of resources
constraint totalRecruit <= totalStrength;

% The total number of overmanned positions should be less than or equal to the total number of recruited resources
constraint totalNumOverman <= totalRecruit;

% The total number of shortworked positions should be less than or equal to the total number of overmanned positions
constraint totalNumShortwork <= totalNumOverman;

% An employee on short-time working meets the production requirements of half a full-time employee
constraint totalNumShortwork * 0.5 <= totalRequirement;

% There is a maximum limit on the manpower that can be recruited in each category
constraint forall(i in 1..K)(Recruit[i] <= Strength[i]);

% Objective
solve minimize totalCostRedundancy;