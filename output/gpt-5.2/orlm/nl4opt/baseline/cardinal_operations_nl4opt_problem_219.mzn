% Science store box production optimization (all data embedded)

int: metal_available = 200;
int: acid_available  = 300;
int: heat_max        = 50;

% Cheap box requirements/outputs
int: cheap_metal = 3;
int: cheap_acid  = 5;
int: cheap_foam  = 8;
int: cheap_heat  = 2;

% Expensive box requirements/outputs
int: exp_metal = 5;
int: exp_acid  = 8;
int: exp_foam  = 10;
int: exp_heat  = 3;

% Decision variables: number of boxes to make
var 0..min(metal_available div cheap_metal, acid_available div cheap_acid): cheap;
var 0..min(metal_available div exp_metal,   acid_available div exp_acid):   expensive;

constraint cheap_metal * cheap + exp_metal * expensive <= metal_available;
constraint cheap_acid  * cheap + exp_acid  * expensive <= acid_available;
constraint cheap_heat  * cheap + exp_heat  * expensive <= heat_max;

var int: total_foam = cheap_foam * cheap + exp_foam * expensive;

solve maximize total_foam;

output [
  "cheap=", show(cheap), "\n",
  "expensive=", show(expensive), "\n",
  "total_foam=", show(total_foam), "\n",
  "metal_used=", show(cheap_metal*cheap + exp_metal*expensive), "\n",
  "acid_used=", show(cheap_acid*cheap + exp_acid*expensive), "\n",
  "heat=", show(cheap_heat*cheap + exp_heat*expensive), "\n"
];