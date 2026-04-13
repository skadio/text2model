% Parameters
int: total_land = 100;
int: prod_heap = 3;
int: prod_vat  = 5;

int: waste_heap = 8;
int: waste_vat  = 17;
int: max_waste  = 90;

int: mach_heap = 10;
int: mach_vat  = 20;
int: max_mach  = 100;

% Variables
var 0..total_land: land_heap;
var 0..total_land: land_vat;

var int: total_production;

% Constraints
constraint land_heap + land_vat <= total_land;

constraint mach_heap * land_heap + mach_vat * land_vat <= max_mach;

constraint waste_heap * land_heap + waste_vat * land_vat <= max_waste;

constraint total_production = prod_heap * land_heap + prod_vat * land_vat;

% Objective
solve maximize total_production;