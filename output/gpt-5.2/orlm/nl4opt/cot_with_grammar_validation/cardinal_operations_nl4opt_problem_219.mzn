% Parameters
int: metal_available = 200;
int: acid_available = 300;
int: heat_limit = 50;

int: cheap_metal = 3;
int: cheap_acid = 5;
int: cheap_foam = 8;
int: cheap_heat = 2;

int: expensive_metal = 5;
int: expensive_acid = 8;
int: expensive_foam = 10;
int: expensive_heat = 3;

% Variables
var 0..min(metal_available div cheap_metal, min(acid_available div cheap_acid, heat_limit div cheap_heat)): cheap_boxes;
var 0..min(metal_available div expensive_metal, min(acid_available div expensive_acid, heat_limit div expensive_heat)): expensive_boxes;

var 0..(cheap_foam * (metal_available div cheap_metal) + expensive_foam * (metal_available div expensive_metal)): total_foam;

% Constraints
constraint
  cheap_metal * cheap_boxes + expensive_metal * expensive_boxes <= metal_available;

constraint
  cheap_acid * cheap_boxes + expensive_acid * expensive_boxes <= acid_available;

constraint
  cheap_heat * cheap_boxes + expensive_heat * expensive_boxes <= heat_limit;

constraint
  total_foam = cheap_foam * cheap_boxes + expensive_foam * expensive_boxes;

% Objective
solve maximize total_foam;