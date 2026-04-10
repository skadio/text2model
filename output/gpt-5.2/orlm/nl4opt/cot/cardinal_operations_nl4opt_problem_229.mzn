% Parameters (with values embedded)
int: total_land = 100;                 % square miles
int: total_machines = 100;             % machines available
int: max_wastewater = 90;              % tons/day

int: prod_heap = 3;                    % tons/day per sq mile
int: waste_heap = 8;                   % tons/day per sq mile
int: mach_heap = 10;                   % machines per sq mile

int: prod_vat = 5;                     % tons/day per sq mile
int: waste_vat = 17;                   % tons/day per sq mile
int: mach_vat = 20;                    % machines per sq mile

% Variables
var 0.0..total_land: heap_land;        % sq miles using heap leaching
var 0.0..total_land: vat_land;         % sq miles using vat leaching

var 0.0..(prod_heap*total_land + prod_vat*total_land): total_production;

% Constraints
constraint heap_land + vat_land <= total_land;

constraint mach_heap * heap_land + mach_vat * vat_land <= total_machines;

constraint waste_heap * heap_land + waste_vat * vat_land <= max_wastewater;

constraint total_production = prod_heap * heap_land + prod_vat * vat_land;

% Objective
solve maximize total_production;