include "globals.mzn";

% Data (embedded from problem statement)
int: Mg_per_gummy = 3;
int: Zn_per_gummy = 4;
int: Mg_per_pill  = 2;
int: Zn_per_pill  = 5;

int: min_pills = 10;
int: gummy_to_pill_ratio = 3;   % gummies >= 3 * pills
int: max_Mg = 200;

% Decision variables
var 0..max_Mg div min(Mg_per_gummy, Mg_per_pill): gummies;
var min_pills..max_Mg div Mg_per_pill: pills;

% Constraints
constraint Mg_per_gummy * gummies + Mg_per_pill * pills <= max_Mg;
constraint gummies >= gummy_to_pill_ratio * pills;

% Objective: maximize total zinc intake
var int: total_Zn = Zn_per_gummy * gummies + Zn_per_pill * pills;
solve maximize total_Zn;

output [
  "gummies = ", show(gummies), "\n",
  "pills = ", show(pills), "\n",
  "total_Mg = ", show(Mg_per_gummy * gummies + Mg_per_pill * pills), "\n",
  "total_Zn = ", show(total_Zn), "\n"
];