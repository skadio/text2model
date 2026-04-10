% Radiation treatment optimization (embedded data)

% Decision variables: minutes each beam is used (nonnegative)
var float: x1 >= 0.0; % minutes for Beam 1
var float: x2 >= 0.0; % minutes for Beam 2

% Data (dose rates: units per minute)
float: pancreas_b1 = 0.3;
float: skin_b1     = 0.2;
float: tumor_b1    = 0.6;

float: pancreas_b2 = 0.2;
float: skin_b2     = 0.1;
float: tumor_b2    = 0.4;

% Limits
float: skin_max  = 4.0;
float: tumor_min = 3.0;

% Constraints
constraint skin_b1 * x1 + skin_b2 * x2 <= skin_max;
constraint tumor_b1 * x1 + tumor_b2 * x2 >= tumor_min;

% Objective: minimize total pancreas dose
var float: pancreas_dose = pancreas_b1 * x1 + pancreas_b2 * x2;
solve minimize pancreas_dose;

output [
  "Beam1_minutes = ", show(x1), "\n",
  "Beam2_minutes = ", show(x2), "\n",
  "Pancreas_dose = ", show(pancreas_dose), "\n",
  "Skin_dose     = ", show(skin_b1*x1 + skin_b2*x2), "\n",
  "Tumor_dose    = ", show(tumor_b1*x1 + tumor_b2*x2), "\n"
];