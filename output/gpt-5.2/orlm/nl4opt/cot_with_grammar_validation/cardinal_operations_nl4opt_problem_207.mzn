% Parameters
int: sticks_per_beam = 30;
int: glue_per_beam = 5;
int: mass_per_beam = 40;

int: sticks_per_truss = 50;
int: glue_per_truss = 8;
int: mass_per_truss = 60;

int: sticks_available = 600;
int: glue_available = 100;

int: max_truss = 5;

% Variables
var 0..(sticks_available div sticks_per_beam): beam;
var 0..max_truss: truss;

var 0..(mass_per_beam * (sticks_available div sticks_per_beam) + mass_per_truss * max_truss): total_mass;

% Constraints
constraint sticks_per_beam * beam + sticks_per_truss * truss <= sticks_available;
constraint glue_per_beam * beam + glue_per_truss * truss <= glue_available;

constraint beam > truss;

constraint total_mass = mass_per_beam * beam + mass_per_truss * truss;

% Objective
solve maximize total_mass;