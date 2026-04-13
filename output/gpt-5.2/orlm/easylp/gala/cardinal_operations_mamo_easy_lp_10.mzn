% Renewable portfolio investment (integer linear optimization)

% Data (embedded from description)
int: costSolar = 7;
int: costWind  = 5;

% Decision variables: number of projects (whole numbers)
var 0..100: solar;
var 0..100: wind;

% Constraints
constraint 2 * solar + 3 * wind >= 10;
constraint 4 * solar + 1 * wind <= 15;

% Objective: minimize total investment cost
var int: totalCost = costSolar * solar + costWind * wind;

solve minimize totalCost;

output [
  "solar = ", show(solar), "\n",
  "wind = ", show(wind), "\n",
  "min_total_cost = ", show(totalCost), "\n"
];