% Minimum-cost pill selection to meet daily medicine requirements

% Data (embedded)
float: req_Z1 = 5.0;
float: req_D3 = 10.0;

float: Z1_in_Zodiac = 1.3;
float: Z1_in_Sunny  = 1.2;

float: D3_in_Zodiac = 1.5;
float: D3_in_Sunny  = 5.0;

float: cost_Zodiac = 1.0;
float: cost_Sunny  = 3.0;

% Decision variables (LP: continuous nonnegative)
var float: xZodiac >= 0.0;  % number of Zodiac pills
var float: xSunny  >= 0.0;  % number of Sunny pills

% Constraints: meet requirements
constraint Z1_in_Zodiac * xZodiac + Z1_in_Sunny * xSunny >= req_Z1;
constraint D3_in_Zodiac * xZodiac + D3_in_Sunny * xSunny >= req_D3;

% Objective: minimize total cost
var float: total_cost = cost_Zodiac * xZodiac + cost_Sunny * xSunny;
solve minimize total_cost;

output [
  "Zodiac pills = ", show(xZodiac), "\n",
  "Sunny pills  = ", show(xSunny), "\n",
  "Total cost   = $", show(total_cost), "\n"
];