include "globals.mzn";

% Input data
array[1..3, 1..3] of int: Requirement;  % Estimated manpower requirements
array[1..3] of var 0..2000: Recruit;     % Number of recruited resources of each type
array[1..3] of int: Strength = [2000, 1500, 1000];  % Strength of each type of resource
array[1..3] of float: LessOneWaste = [0.25, 0.2, 0.1];  % Wastage when less than optimal
array[1..3] of float: MoreOneWaste = [0.1, 0.05, 0.05];  % Wastage when more than optimal
array[1..3] of int: CostRedundancy = [200, 500, 500];  % Cost of redundancy for each type of resource
int: NumOverman;  % Number of overmanned positions
array[1..3] of int: CostOverman = [1500, 2000, 3000];  % Cost of overmanning for each type of resource
int: NumShortwork;  % Number of shortworked positions
array[1..3] of int: CostShort = [500, 400, 400];  % Cost of short working for each type of resource

% Constraints
constraint count(Recruit, 0, 500);  % At most 500 recruits of any type

% Objective: Minimize redundancy
var int: totalRedundancy = sum(i in 1..3)(CostRedundancy[i] * (max(0, sum(j in 1..3)(Requirement[i,j]) - Strength[i] - Recruit[i])));
var int: totalOverman = sum(i in 1..3)(CostOverman[i] * max(0, sum(j in 1..3)(Requirement[i,j]) - Strength[i] - Recruit[i] - NumOverman));
var int: totalShortwork = sum(i in 1..3)(CostShort[i] * max(0, NumShortwork));

var int: totalCost = totalRedundancy + totalOverman + totalShortwork;

% Solve
solve minimize totalCost;

% Output
output [
    "Recruit = ", show(Recruit), "\n",
    "Total Cost = ", show(totalCost), "\n"
];