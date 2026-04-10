% Ayse's fertilizer mixing problem (embedded data)

% Decision variables: kg of each fertilizer
var float: xC >= 0.0;   % kg of Fertilizer C
var float: xY >= 0.0;   % kg of Fertilizer Y

% Requirements (units)
float: minNitrous = 5.0;
float: minVitamin = 8.0;

% Composition (units per kg)
float: nitrousC = 1.5;
float: vitaminC = 3.0;

float: nitrousY = 5.0;
float: vitaminY = 1.0;

% Costs ($ per kg)
float: costC = 2.0;
float: costY = 3.0;

% Constraints: meet minimum requirements
constraint nitrousC * xC + nitrousY * xY >= minNitrous;
constraint vitaminC * xC + vitaminY * xY >= minVitamin;

% Objective: minimize total cost
var float: totalCost = costC * xC + costY * xY;

solve minimize totalCost;

output [
  "xC (kg) = ", show(xC), "\n",
  "xY (kg) = ", show(xY), "\n",
  "Total cost ($) = ", show(totalCost), "\n",
  "Nitrous provided = ", show(nitrousC*xC + nitrousY*xY), "\n",
  "Vitamin provided = ", show(vitaminC*xC + vitaminY*xY), "\n"
];