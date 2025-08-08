int: P;                                      % Number of power plants
int: C;                                      % Number of cities

array[1..P] of int: Supply;                  % Electricity supply capacity for each power plant
array[1..C] of int: Demand;                  % Electricity demand for each city
array[1..P, 1..C] of int: TransmissionCosts; % Transmission cost from power plant p to city c

% Define an upper bound for the flow variables.
% Here we set U to be the maximum of any plant's supply or any city's demand.
int: U = max( max(Supply), max(Demand) );

% Decision Variables: Flow[p, c] is the electricity sent from plant p to city c.
array[1..P, 1..C] of var 0..U: Flow;

% Supply constraints: A power plant cannot send more than its capacity.
constraint
  forall(p in 1..P)(
    sum(c in 1..C)(Flow[p,c]) <= Supply[p]
  );

% Demand constraints: Each city's demand must be exactly met.
constraint
  forall(c in 1..C)(
    sum(p in 1..P)(Flow[p,c]) = Demand[c]
  );

% Objective: Minimize the total transmission cost.
var int: TotalCost = sum(p in 1..P, c in 1..C)(
  TransmissionCosts[p, c] * Flow[p, c]
);

solve minimize TotalCost;

output [
  "TotalCost = ", show(TotalCost), "\n",
  "Flow matrix:\n", join([ show([Flow[p,c] | c in 1..C]) ++ "\n" | p in 1..P])
];