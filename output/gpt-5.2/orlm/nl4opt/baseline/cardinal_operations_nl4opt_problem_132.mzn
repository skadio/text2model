% Desk and Drawer Production Optimization (all data embedded)

int: assembly_desk = 40;
int: sanding_desk  = 20;
int: assembly_drawer = 30;
int: sanding_drawer  = 10;

int: assembly_available = 4000;
int: sanding_available  = 3500;

int: profit_desk = 100;
int: profit_drawer = 90;

var 0..assembly_available div min(assembly_desk, assembly_drawer): desks;
var 0..assembly_available div min(assembly_desk, assembly_drawer): drawers;

constraint assembly_desk * desks + assembly_drawer * drawers <= assembly_available;
constraint sanding_desk  * desks + sanding_drawer  * drawers <= sanding_available;

var int: total_profit = profit_desk * desks + profit_drawer * drawers;

solve maximize total_profit;

output [
  "desks=", show(desks), "\n",
  "drawers=", show(drawers), "\n",
  "total_profit=$", show(total_profit), "\n"
];