% Mining techniques allocation (heap vs vat) to maximize daily production
% Data embedded as required.

include "globals.mzn";

% Parameters
int: total_land = 100;          % square miles available
int: machines_avail = 100;      % extraction machines available
int: wastewater_max = 90;       % tons/day maximum polluted wastewater

% Per square mile coefficients
int: prod_heap = 3;             % tons/day
int: waste_heap = 8;            % tons/day
int: mach_heap = 10;            % machines

int: prod_vat = 5;              % tons/day
int: waste_vat = 17;            % tons/day
int: mach_vat = 20;             % machines

% Decision variables: land allocated to each technique (square miles)
var 0..total_land: land_heap;
var 0..total_land: land_vat;

% Constraints
constraint land_heap + land_vat <= total_land;
constraint mach_heap * land_heap + mach_vat * land_vat <= machines_avail;
constraint waste_heap * land_heap + waste_vat * land_vat <= wastewater_max;

% Objective: maximize daily production
var int: total_production = prod_heap * land_heap + prod_vat * land_vat;

solve maximize total_production;

output [
  "land_heap = ", show(land_heap), " sq mi\n",
  "land_vat  = ", show(land_vat), " sq mi\n",
  "total_land_used = ", show(land_heap + land_vat), " / ", show(total_land), "\n",
  "machines_used = ", show(mach_heap * land_heap + mach_vat * land_vat), " / ", show(machines_avail), "\n",
  "wastewater = ", show(waste_heap * land_heap + waste_vat * land_vat), " / ", show(wastewater_max), "\n",
  "total_production = ", show(total_production), " tons/day\n",
  "proportion_heap = ", show(land_heap), "/", show(total_land), "\n",
  "proportion_vat  = ", show(land_vat), "/", show(total_land), "\n"
];