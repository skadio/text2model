% Mining technique allocation (LP)
% All data embedded as per problem statement.

% Parameters
int: total_land = 100;
int: machines_available = 100;
int: wastewater_max = 90;

int: prod_heap = 3;
int: water_heap = 8;
int: mach_heap = 10;

int: prod_vat = 5;
int: water_vat = 17;
int: mach_vat = 20;

% Use floats to model proportions/real-valued land allocations
var float: land_heap;
var float: land_vat;

constraint land_heap >= 0.0 /\ land_heap <= float(total_land);
constraint land_vat  >= 0.0 /\ land_vat  <= float(total_land);

% Constraints
constraint land_heap + land_vat <= float(total_land);

constraint float(mach_heap) * land_heap + float(mach_vat) * land_vat
          <= float(machines_available);

constraint float(water_heap) * land_heap + float(water_vat) * land_vat
          <= float(wastewater_max);

% Objective
var float: total_production =
  float(prod_heap) * land_heap + float(prod_vat) * land_vat;

solve maximize total_production;

output [
  "land_heap = ", show(land_heap), "\n",
  "land_vat = ", show(land_vat), "\n",
  "total_production = ", show(total_production), "\n"
];