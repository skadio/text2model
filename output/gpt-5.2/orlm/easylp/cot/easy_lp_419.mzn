% Parameters (with values embedded)
int: budget = 80;
int: min_score = 100;

int: solar_cost = 10;
int: wind_cost  = 20;

int: solar_max = 50;
int: wind_max  = 40;

% Variables
var 0..solar_max: Solar;
var 0..wind_max: Wind;
var 0..(solar_cost*solar_max + wind_cost*wind_max): TotalCost;

% Constraints
constraint Solar + Wind <= budget;
constraint 3*Solar + 2*Wind >= min_score;
constraint Solar >= Wind;

constraint TotalCost = solar_cost*Solar + wind_cost*Wind;

% Objective
solve minimize TotalCost;

output [
  "Solar=", show(Solar), "\n",
  "Wind=", show(Wind), "\n",
  "TotalCost=", show(TotalCost), "\n"
];