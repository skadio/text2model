% Radiation treatment optimization (all data embedded)

include "globals.mzn";

% Decision variables: minutes each beam is used
var 0..1000: b1;  % minutes for Beam 1
var 0..1000: b2;  % minutes for Beam 2

% Data (dose rates per minute)
float: pan_b1 = 0.3;
float: skin_b1 = 0.2;
float: tumor_b1 = 0.6;

float: pan_b2 = 0.2;
float: skin_b2 = 0.1;
float: tumor_b2 = 0.4;

% Constraints
constraint skin_b1 * b1 + skin_b2 * b2 <= 4.0;   % skin dose at most 4
constraint tumor_b1 * b1 + tumor_b2 * b2 >= 3.0; % tumor dose at least 3

% Objective: minimize pancreas dose
var float: pancreas = pan_b1 * b1 + pan_b2 * b2;
solve minimize pancreas;

output [
  "Beam1_minutes = ", show(b1), "\n",
  "Beam2_minutes = ", show(b2), "\n",
  "PancreasDose  = ", show(pancreas), "\n",
  "SkinDose      = ", show(skin_b1*b1 + skin_b2*b2), "\n",
  "TumorDose     = ", show(tumor_b1*b1 + tumor_b2*b2), "\n"
];