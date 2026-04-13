% Grandma's medicine pill planning (LP solved as MILP with integer pills)

include "globals.mzn";

% -------------------------
% Data (embedded)
% -------------------------
float: req_Z1 = 5.0;     % grams per day
float: req_D3 = 10.0;    % grams per day

float: Z1_Zodiac = 1.3;
float: Z1_Sunny  = 1.2;

float: D3_Zodiac = 1.5;
float: D3_Sunny  = 5.0;

int: cost_Zodiac = 1;    % $ per pill
int: cost_Sunny  = 3;

% -------------------------
% Decision variables
% -------------------------
% Number of pills (assumed integer pills)
var 0..100: xZodiac;
var 0..100: xSunny;

% -------------------------
% Constraints (scaled to avoid floats)
% Multiply Z1 constraints by 10: 1.3 -> 13, 1.2 -> 12, 5.0 -> 50
constraint 13 * xZodiac + 12 * xSunny >= 50;

% Multiply D3 constraints by 2: 1.5 -> 3, 5.0 -> 10, 10.0 -> 20
constraint 3 * xZodiac + 10 * xSunny >= 20;

% -------------------------
% Objective: minimize total cost
% -------------------------
var int: totalCost = cost_Zodiac * xZodiac + cost_Sunny * xSunny;
solve minimize totalCost;

% -------------------------
% Output
% -------------------------
output [
  "Zodiac pills = ", show(xZodiac), "\n",
  "Sunny pills  = ", show(xSunny), "\n",
  "Total cost   = $", show(totalCost), "\n",
  "Z1 provided  = ", show(1.3 * int2float(xZodiac) + 1.2 * int2float(xSunny)), " g\n",
  "D3 provided  = ", show(1.5 * int2float(xZodiac) + 5.0 * int2float(xSunny)), " g\n"
];