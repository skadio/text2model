% Party transport: minimize total vehicles while meeting capacity and limo proportion

int: limo_capacity = 12;
int: bus_capacity  = 18;
int: min_people    = 400;

% Decision variables
var 0..1000: L; % number of limousines
var 0..1000: B; % number of buses

% Constraints
constraint limo_capacity * L + bus_capacity * B >= min_people;

% At least 70% of vehicles are limousines:
% L / (L+B) >= 0.7  -> 10L >= 7(L+B) -> 3L >= 7B
constraint 3 * L >= 7 * B;

% Objective: minimize total vehicles used
solve minimize L + B;

output [
  "Limousines = ", show(L), "\n",
  "Buses      = ", show(B), "\n",
  "Total      = ", show(L + B), "\n",
  "Capacity   = ", show(limo_capacity * L + bus_capacity * B), "\n"
];