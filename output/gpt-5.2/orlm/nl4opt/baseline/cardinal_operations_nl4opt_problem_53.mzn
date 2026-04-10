% Ayse fertilizer blending - minimum cost

% Data
float: req_nitrous = 5.0;
float: req_vitamin = 8.0;

float: costC = 2.0;
float: costY = 3.0;

float: nitrousC = 1.5;
float: vitaminC = 3.0;

float: nitrousY = 5.0;
float: vitaminY = 1.0;

% Decision variables: kg of each fertilizer (nonnegative)
var 0.0..1000.0: xC;
var 0.0..1000.0: xY;

% Constraints: meet minimum nutrient requirements
constraint nitrousC * xC + nitrousY * xY >= req_nitrous;
constraint vitaminC * xC + vitaminY * xY >= req_vitamin;

% Objective: minimize cost
var float: total_cost = costC * xC + costY * xY;
solve minimize total_cost;

output [
  "C_kg = ", show(xC), "\n",
  "Y_kg = ", show(xY), "\n",
  "min_cost = $", show(total_cost), "\n"
];