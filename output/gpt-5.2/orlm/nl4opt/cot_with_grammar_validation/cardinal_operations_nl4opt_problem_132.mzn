% Parameters
int: desk_assembly = 40;
int: desk_sanding  = 20;
int: drawer_assembly = 30;
int: drawer_sanding  = 10;

int: assembly_available = 4000;
int: sanding_available  = 3500;

int: profit_desk   = 100;
int: profit_drawer = 90;

% Variables
var 0..(assembly_available div desk_assembly): desks;
var 0..(assembly_available div drawer_assembly): drawers;

% Constraints
constraint desk_assembly * desks + drawer_assembly * drawers <= assembly_available;
constraint desk_sanding  * desks + drawer_sanding  * drawers <= sanding_available;

% Objective
solve maximize profit_desk * desks + profit_drawer * drawers;