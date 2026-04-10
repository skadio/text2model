% Bridge building optimization (all data embedded)

include "globals.mzn";

% Parameters
int: sticks_max = 600;
int: glue_max   = 100;

int: sticks_beam  = 30;
int: glue_beam    = 5;
int: mass_beam    = 40;

int: sticks_truss = 50;
int: glue_truss   = 8;
int: mass_truss   = 60;

int: truss_max = 5;

% Decision variables
var 0..(sticks_max div sticks_beam): beam;
var 0..truss_max: truss;

% Resource constraints
constraint sticks_beam * beam + sticks_truss * truss <= sticks_max;
constraint glue_beam   * beam + glue_truss   * truss <= glue_max;

% Additional constraints
constraint beam > truss;

% Objective
var int: total_mass = mass_beam * beam + mass_truss * truss;

solve maximize total_mass;

output [
  "beam = ", show(beam), "\n",
  "truss = ", show(truss), "\n",
  "total_mass = ", show(total_mass), "\n",
  "sticks_used = ", show(sticks_beam*beam + sticks_truss*truss), " / ", show(sticks_max), "\n",
  "glue_used = ", show(glue_beam*beam + glue_truss*truss), " / ", show(glue_max), "\n"
];