% Maple Oil blending/processing optimization (LP)

% Decision variables: number of (possibly partial) tanks to process
var float: light;
var float: non_sticky;
var float: heavy;

% Nonnegativity
constraint light >= 0.0;
constraint non_sticky >= 0.0;
constraint heavy >= 0.0;

% Resources available
float: A_avail = 250.0;
float: B_avail = 150.0;

% Resource usage per tank
float: A_light = 3.0;  float: B_light = 3.0;
float: A_non  = 6.0;  float: B_non  = 2.0;
float: A_heavy= 9.0;  float: B_heavy= 3.0;

% Resource constraints
constraint A_light*light + A_non*non_sticky + A_heavy*heavy <= A_avail;
constraint B_light*light + B_non*non_sticky + B_heavy*heavy <= B_avail;

% Revenues per tank
float: R_light = 550.0;
float: R_non   = 750.0;
float: R_heavy = 950.0;

% Objective: maximize net revenue
var float: revenue = R_light*light + R_non*non_sticky + R_heavy*heavy;

solve maximize revenue;

output [
  "light_tanks = ", show(light), "\n",
  "non_sticky_tanks = ", show(non_sticky), "\n",
  "heavy_tanks = ", show(heavy), "\n",
  "max_revenue = ", show(revenue), "\n"
];