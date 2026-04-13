% Feed mix (linear optimization) - all data embedded

% Decision variables (kg of each feed)
var 0.0..1000.0: xA;  % Feed A
var 0.0..1000.0: xB;  % Feed B

% Nutrient constraints
constraint 10.0 * xA + 7.0 * xB >= 30.0;   % protein
constraint  8.0 * xA + 15.0 * xB >= 50.0;  % fat

% Objective: minimize cost
var float: total_cost = 100.0 * xA + 80.0 * xB;

solve minimize total_cost;

output [
  "Feed A (kg) = ", show(xA), "\n",
  "Feed B (kg) = ", show(xB), "\n",
  "Total cost  = $", show(total_cost), "\n",
  "Protein     = ", show(10.0*xA + 7.0*xB), "\n",
  "Fat         = ", show(8.0*xA + 15.0*xB), "\n"
];