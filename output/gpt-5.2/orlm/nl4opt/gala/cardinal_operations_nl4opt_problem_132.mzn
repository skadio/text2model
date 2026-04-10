% Desk & drawer production planning (maximize profit)
include "globals.mzn";

% Data (embedded as requested)
int: assembly_avail = 4000;   % minutes
int: sanding_avail  = 3500;   % minutes

int: a_desk = 40;             % assembly minutes per desk
int: s_desk = 20;             % sanding minutes per desk
int: p_desk = 100;            % profit per desk ($)

int: a_drawer = 30;           % assembly minutes per drawer
int: s_drawer = 10;           % sanding minutes per drawer
int: p_drawer = 90;           % profit per drawer ($)

% Decision variables (nonnegative integers)
var 0..assembly_avail div min(a_desk, a_drawer): desks;
var 0..assembly_avail div min(a_desk, a_drawer): drawers;

% Resource constraints
constraint a_desk * desks + a_drawer * drawers <= assembly_avail;
constraint s_desk * desks + s_drawer * drawers <= sanding_avail;

% Objective
var int: profit = p_desk * desks + p_drawer * drawers;

solve maximize profit;

output [
  "desks = ", show(desks), "\n",
  "drawers = ", show(drawers), "\n",
  "profit = ", show(profit), "\n",
  "assembly_used = ", show(a_desk * desks + a_drawer * drawers), " / ", show(assembly_avail), "\n",
  "sanding_used = ", show(s_desk * desks + s_drawer * drawers), " / ", show(sanding_avail), "\n"
];