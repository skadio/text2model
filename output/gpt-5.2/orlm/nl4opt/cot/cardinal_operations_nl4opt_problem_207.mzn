% Parameters (with values embedded)
int: stick_limit = 600;
int: glue_limit = 100;

int: sticks_beam = 30;
int: glue_beam  = 5;
int: mass_beam  = 40;

int: sticks_truss = 50;
int: glue_truss  = 8;
int: mass_truss  = 60;

int: truss_max = 5;

% Variables
var 0..(stick_limit div sticks_beam): beam;
var 0..truss_max: truss;
var 0..100000: total_mass;

% Constraints
constraint sticks_beam * beam + sticks_truss * truss <= stick_limit;
constraint glue_beam  * beam + glue_truss  * truss <= glue_limit;

constraint truss <= truss_max;
constraint beam > truss;

constraint total_mass = mass_beam * beam + mass_truss * truss;

% Objective
solve maximize total_mass;