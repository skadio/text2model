% Slime production optimization (all data embedded)

include "globals.mzn";

% Data
int: powder_avail = 100;
int: glue_avail   = 90;
int: mess_max     = 30;

% Table 1: uses 3 powder, 5 glue -> 4 slime; makes 2 mess
% Table 2: uses 8 powder, 6 glue -> 5 slime; makes 4 mess

% Decision variables: number of each table to set up (nonnegative integers)
% Simple safe upper bounds derived from resources
var 0..min(powder_avail div 3, glue_avail div 5): t1;
var 0..min(powder_avail div 8, glue_avail div 6): t2;

% Resource constraints
constraint 3*t1 + 8*t2 <= powder_avail;
constraint 5*t1 + 6*t2 <= glue_avail;
constraint 2*t1 + 4*t2 <= mess_max;

% Objective: maximize total slime produced
var int: slime = 4*t1 + 5*t2;

solve maximize slime;

output [
  "t1 (tables) = ", show(t1), "\n",
  "t2 (tables) = ", show(t2), "\n",
  "slime        = ", show(slime), "\n",
  "powder used  = ", show(3*t1 + 8*t2), " / ", show(powder_avail), "\n",
  "glue used    = ", show(5*t1 + 6*t2), " / ", show(glue_avail), "\n",
  "mess made    = ", show(2*t1 + 4*t2), " / ", show(mess_max), "\n"
];