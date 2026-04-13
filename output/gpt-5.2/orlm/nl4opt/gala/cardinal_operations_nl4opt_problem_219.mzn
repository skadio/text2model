% Science store box production optimization (integer linear programming)

include "globals.mzn";

% Data (embedded as required)
int: metal_avail = 200;
int: acid_avail  = 300;
int: heat_max    = 50;

% Cheap box
int: metal_c = 3;
int: acid_c  = 5;
int: foam_c  = 8;
int: heat_c  = 2;

% Expensive box
int: metal_e = 5;
int: acid_e  = 8;
int: foam_e  = 10;
int: heat_e  = 3;

% Decision variables: number of boxes to make (nonnegative integers)
var 0..metal_avail div min(metal_c, metal_e): cheap;
var 0..metal_avail div min(metal_c, metal_e): expensive;

% Resource constraints
constraint metal_c * cheap + metal_e * expensive <= metal_avail;
constraint acid_c  * cheap + acid_e  * expensive <= acid_avail;
constraint heat_c  * cheap + heat_e  * expensive <= heat_max;

% Objective: maximize foam produced
var int: total_foam = foam_c * cheap + foam_e * expensive;
solve maximize total_foam;

output [
  "cheap = ", show(cheap), "\n",
  "expensive = ", show(expensive), "\n",
  "total_foam = ", show(total_foam), "\n",
  "metal_used = ", show(metal_c * cheap + metal_e * expensive), " / ", show(metal_avail), "\n",
  "acid_used = ",  show(acid_c  * cheap + acid_e  * expensive), " / ", show(acid_avail), "\n",
  "heat = ",       show(heat_c  * cheap + heat_e  * expensive), " / ", show(heat_max), "\n"
];