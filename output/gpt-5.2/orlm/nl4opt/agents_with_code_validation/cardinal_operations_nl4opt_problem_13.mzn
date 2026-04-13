% Radiation treatment planning (LP)
% Minimize total dose to pancreas subject to skin cap and tumor minimum.

% Parameters (dose rates per minute)
float: pancreas_beam1 = 0.3;
float: skin_beam1     = 0.2;
float: tumor_beam1    = 0.6;

float: pancreas_beam2 = 0.2;
float: skin_beam2     = 0.1;
float: tumor_beam2    = 0.4;

float: max_skin_dose  = 4.0;
float: min_tumor_dose = 3.0;

% Decision variables: minutes for each beam (continuous, nonnegative)
var float: m1;
var float: m2;

% Constraints
constraint m1 >= 0.0 /\ m2 >= 0.0;

% Skin dose limit
constraint skin_beam1 * m1 + skin_beam2 * m2 <= max_skin_dose;

% Tumor dose minimum
constraint tumor_beam1 * m1 + tumor_beam2 * m2 >= min_tumor_dose;

% Objective: minimize pancreas dose
var float: pancreas_dose = pancreas_beam1 * m1 + pancreas_beam2 * m2;
solve minimize pancreas_dose;

output [
  "minutes_beam1 = ", show(m1), "\n",
  "minutes_beam2 = ", show(m2), "\n",
  "pancreas_dose = ", show(pancreas_dose), "\n",
  "skin_dose = ", show(skin_beam1 * m1 + skin_beam2 * m2), "\n",
  "tumor_dose = ", show(tumor_beam1 * m1 + tumor_beam2 * m2), "\n"
];