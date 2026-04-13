% Parameters (with values embedded)
int: assembly_time_desk = 40;
int: sanding_time_desk  = 20;
int: assembly_time_drawer = 30;
int: sanding_time_drawer  = 10;

int: assembly_available = 4000;
int: sanding_available  = 3500;

int: profit_desk   = 100;
int: profit_drawer = 90;

% Upper bounds from resources (safe explicit bounds)
int: max_desks   = min(assembly_available div assembly_time_desk,
                       sanding_available  div sanding_time_desk);
int: max_drawers = min(assembly_available div assembly_time_drawer,
                       sanding_available  div sanding_time_drawer);

% Variables
var 0..max_desks: desks;
var 0..max_drawers: drawers;

% Constraints
constraint assembly_time_desk * desks + assembly_time_drawer * drawers <= assembly_available;
constraint sanding_time_desk  * desks + sanding_time_drawer  * drawers <= sanding_available;

% Objective
var int: total_profit = profit_desk * desks + profit_drawer * drawers;
solve maximize total_profit;

output [
  "desks=", show(desks), "\n",
  "drawers=", show(drawers), "\n",
  "total_profit=", show(total_profit), "\n"
];