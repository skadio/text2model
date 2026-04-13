% Carbon dioxide production optimization (embedded data)

include "globals.mzn";

% Data (from problem statement)
int: wood_avail   = 300;
int: oxy_avail    = 300;

int: wood_cat     = 10;
int: oxy_cat      = 20;
int: co2_cat      = 15;

int: wood_nocat   = 15;
int: oxy_nocat    = 12;
int: co2_nocat    = 18;

% Decision variables: number of runs of each process (nonnegative integers)
var 0..wood_avail div min(wood_cat, wood_nocat): x_cat;
var 0..wood_avail div min(wood_cat, wood_nocat): x_nocat;

% Resource constraints
constraint wood_cat * x_cat + wood_nocat * x_nocat <= wood_avail;
constraint oxy_cat  * x_cat + oxy_nocat  * x_nocat <= oxy_avail;

% Objective: maximize total CO2
var 0..(co2_cat * (wood_avail div wood_cat) + co2_nocat * (wood_avail div wood_nocat)): total_co2;
constraint total_co2 = co2_cat * x_cat + co2_nocat * x_nocat;

solve maximize total_co2;

output [
  "x_cat = ", show(x_cat), "\n",
  "x_nocat = ", show(x_nocat), "\n",
  "total_co2 = ", show(total_co2), "\n",
  "wood_used = ", show(wood_cat * x_cat + wood_nocat * x_nocat), " / ", show(wood_avail), "\n",
  "oxygen_used = ", show(oxy_cat * x_cat + oxy_nocat * x_nocat), " / ", show(oxy_avail), "\n"
];