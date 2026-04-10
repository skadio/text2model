% Mining land allocation (LP) - maximize rare earth oxide production

% Parameters (embedded data)
int: total_land = 100;            % square miles
int: prod_heap = 3;               % tons/sq mile/day
int: waste_heap = 8;              % tons/sq mile/day
int: machines_heap = 10;          % machines/sq mile

int: prod_vat = 5;                % tons/sq mile/day
int: waste_vat = 17;              % tons/sq mile/day
int: machines_vat = 20;           % machines/sq mile

int: machines_available = 100;    % machines
int: waste_max = 90;              % tons/day

% Decision variables (continuous)
var float: land_heap;             % sq miles using heap leaching
var float: land_vat;              % sq miles using vat leaching

% Objective
var float: total_production;

% Bounds to help the solver and avoid search/timeouts
constraint land_heap >= 0.0 /\ land_heap <= total_land;
constraint land_vat  >= 0.0 /\ land_vat  <= total_land;

% Constraints
constraint land_heap + land_vat <= total_land;
constraint machines_heap * land_heap + machines_vat * land_vat <= machines_available;
constraint waste_heap * land_heap + waste_vat * land_vat <= waste_max;

constraint total_production = prod_heap * land_heap + prod_vat * land_vat;

solve maximize total_production;

output [
  "land_heap = ", show(land_heap), " sq mi\n",
  "land_vat  = ", show(land_vat),  " sq mi\n",
  "total_production = ", show(total_production), " tons/day\n"
];