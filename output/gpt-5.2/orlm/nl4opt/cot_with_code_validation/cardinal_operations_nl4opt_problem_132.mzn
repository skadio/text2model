% Parameters
int: assembly_per_desk = 40;
int: sanding_per_desk  = 20;
int: assembly_per_drawer = 30;
int: sanding_per_drawer  = 10;

int: assembly_available = 4000;
int: sanding_available  = 3500;

int: profit_per_desk = 100;
int: profit_per_drawer = 90;

% Variables
var 0..(assembly_available div assembly_per_desk): desks;
var 0..(assembly_available div assembly_per_drawer): drawers;
var 0..(profit_per_desk*(assembly_available div assembly_per_desk) + profit_per_drawer*(assembly_available div assembly_per_drawer)): total_profit;

% Constraints
constraint assembly_per_desk * desks + assembly_per_drawer * drawers <= assembly_available;
constraint sanding_per_desk  * desks + sanding_per_drawer  * drawers <= sanding_available;

constraint total_profit = profit_per_desk * desks + profit_per_drawer * drawers;

% Objective
solve maximize total_profit;