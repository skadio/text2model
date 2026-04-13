% Parameters
int: nCities = 5;                         % Number of cities
set of int: Cities = 1..nCities;          % City indices

array[Cities, Cities] of int: cost =      % Travel cost matrix (cost[i,j])
[
|  0, 58, 15, 75, 91
| 58,  0, 54, 85, 11
| 15, 54,  0, 28, 61
| 75, 85, 28,  0, 47
| 91, 11, 61, 47,  0
];

int: maxArcCost = max([cost[i,j] | i in Cities, j in Cities]); % Upper bound for arc cost
int: maxTourCost = nCities * maxArcCost;                       % Crude upper bound for tour cost

% Variables
array[Cities] of var Cities: succ;        % succ[i] = next city visited after i
var 0..maxTourCost: totalCost;            % Total travel cost of the Hamiltonian cycle

% Constraints
% Hamiltonian cycle structure: each city has exactly one successor and one predecessor
constraint circuit(succ);

% Define total tour cost as the sum of costs of chosen arcs i -> succ[i]
constraint totalCost = sum(i in Cities)(cost[i, succ[i]]);

% Objective
solve minimize totalCost;