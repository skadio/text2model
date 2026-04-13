% Parameters
int: total_land = 100;
int: max_machines = 100;
int: max_wastewater = 90;

int: prod_heap = 3;
int: prod_vat = 5;

int: waste_heap = 8;
int: waste_vat = 17;

int: mach_heap = 10;
int: mach_vat = 20;

% Variables
var 0..total_land: land_heap;
var 0..total_land: land_vat;

% Constraints
constraint land_heap + land_vat <= total_land;

constraint mach_heap * land_heap + mach_vat * land_vat <= max_machines;

constraint waste_heap * land_heap + waste_vat * land_vat <= max_wastewater;

% Objective
var 0..(prod_heap * total_land + prod_vat * total_land): total_production;
constraint total_production = prod_heap * land_heap + prod_vat * land_vat;

solve maximize total_production;