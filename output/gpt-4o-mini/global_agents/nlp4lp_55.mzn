int: P;  % Number of power plants
int: C;  % Number of cities
array[1..P] of int: Supply;  % Electricity supply capacity of power plants
array[1..C] of int: Demand;   % Electricity demand of cities
array[1..P, 1..C] of int: TransmissionCosts;  % Transmission costs

% Decision variables: amount of electricity sent from power plant p to city c
array[1..P, 1..C] of var 0..max(Supply): x;

% Constraints
% Each city's demand must be met
constraint forall(c in 1..C)(
    sum(p in 1..P)(x[p, c]) = Demand[c]
);

% Each power plant's supply capacity must not be exceeded
constraint forall(p in 1..P)(
    sum(c in 1..C)(x[p, c]) <= Supply[p]
);

% Objective: Minimize total transmission cost
var int: totalCost = sum(p in 1..P, c in 1..C)(TransmissionCosts[p, c] * x[p, c]);

solve minimize totalCost;

output [ "Total Cost = ", show(totalCost), "\n", 
         "Electricity sent = ", show(x), "\n" ];