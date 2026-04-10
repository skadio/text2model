% Candy mix optimization (LP)
% Data embedded as per problem description.

% Composition (kg of ingredient per kg of mix)
float: reg_in_regularMix  = 0.8;
float: sour_in_regularMix = 0.2;

float: reg_in_sourMix  = 0.1;
float: sour_in_sourMix = 0.9;

% Profit per kg of each mix
float: profit_regularMix = 3.0;
float: profit_sourMix    = 5.0;

% Available inventory (kg)
float: avail_regularCandy = 80.0;
float: avail_sourCandy    = 60.0;

% Decision variables (kg produced)
var float: kg_regularMix;
var float: kg_sourMix;

% Constraints (inventory + nonnegativity)
constraint kg_regularMix >= 0.0;
constraint kg_sourMix >= 0.0;

constraint reg_in_regularMix * kg_regularMix + reg_in_sourMix * kg_sourMix
        <= avail_regularCandy;

constraint sour_in_regularMix * kg_regularMix + sour_in_sourMix * kg_sourMix
        <= avail_sourCandy;

% Objective: maximize profit
solve maximize profit_regularMix * kg_regularMix + profit_sourMix * kg_sourMix;

output [
  "kg_regularMix = ", show(kg_regularMix), "\n",
  "kg_sourMix = ", show(kg_sourMix), "\n",
  "total_profit = ", show(profit_regularMix * kg_regularMix + profit_sourMix * kg_sourMix), "\n"
];