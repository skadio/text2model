% Parameters
int: ao_blue = 3;
int: min_blue = 5;
int: sugar_blue = 5;

int: ao_straw = 1;
int: min_straw = 7;
int: sugar_straw = 7;

int: req_ao = 90;
int: req_min = 100;

int: ratio_straw_per_blue = 3;

% Variables
var 0..1000: x_blue;   % packs of blueberries
var 0..1000: x_straw;  % packs of strawberries

% Constraints
constraint ao_blue * x_blue + ao_straw * x_straw >= req_ao;
constraint min_blue * x_blue + min_straw * x_straw >= req_min;
constraint x_straw >= ratio_straw_per_blue * x_blue;

% Objective
solve minimize sugar_blue * x_blue + sugar_straw * x_straw;