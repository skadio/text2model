int: K;  % Number of requirement categories
int: I;  % Number of different requirements
array[1..K, 1..I] of int: Requirement;  % Estimated manpower requirements
array[1..K] of int: Strength;  % Strength of each requirement category
array[1..K] of float: LessOneWaste;  % Cost reduction per unit less waste
array[1..K] of float: MoreOneWaste;  % Additional cost per unit more waste
array[1..K] of int: Recruit;  % Number of recruits in each category
array[1..K] of int: CostRedundancy;  % Cost of redundancy per recruit
int: NumOverman;  % Number of over-managed categories allowed
array[1..K] of int: CostOverman;  % Cost of over-managing in each category
int: NumShortwork;  % Number of short-work categories allowed
array[1..K] of int: CostShort;  % Cost of short-work in each category

% Decision variables
array[1..K] of var int: num_recruits;  % Number of recruits in each category
array[1..K] of var int: num_redundancies;  % Number of redundancies in each category
array[1..K] of var int: num_overman;  % Number of over-managed workers in each category
array[1..K] of var int: num_shortwork;  % Number of short-time workers in each category

% Constraints
constraint forall(k in 1..K) (
    num_recruits[k] <= Recruit[k]  % Cannot recruit more than allowed
);

constraint forall(k in 1..K) (
    num_redundancies[k] >= 0  % Redundancies cannot be negative
);

constraint sum(num_overman) <= NumOverman;  % Total over-managed workers must not exceed limit
constraint sum(num_shortwork) <= NumShortwork;  % Total short-time workers must not exceed limit

% Objective function: Minimize costs
var float: total_cost = sum(k in 1..K)(
    CostRedundancy[k] * num_redundancies[k] +
    CostOverman[k] * num_overman[k] +
    CostShort[k] * num_shortwork[k] -
    LessOneWaste[k] * (Strength[k] - sum(Requirement[k, j] | j in 1..I)) +
    MoreOneWaste[k] * (sum(Requirement[k, j] | j in 1..I) - Strength[k])
);

solve minimize total_cost;

output [
    "Total Cost = ", show(total_cost), "\n",
    "Recruits = ", show(num_recruits), "\n",
    "Redundancies = ", show(num_redundancies), "\n",
    "Overman = ", show(num_overman), "\n",
    "Shortwork = ", show(num_shortwork), "\n"
];