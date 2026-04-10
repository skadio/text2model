% Parameters
int: ao_blue = 3;
int: min_blue = 5;
int: sugar_blue = 5;

int: ao_straw = 1;
int: min_straw = 7;
int: sugar_straw = 7;

int: req_ao = 90;
int: req_min = 100;

int: straw_to_blue_ratio = 3;

% Variables
var 0..1000: x_blue;   % packs of blueberries
var 0..1000: x_straw;  % packs of strawberries

var 0..100000: total_sugar;

% Constraints
constraint ao_blue * x_blue + ao_straw * x_straw >= req_ao;
constraint min_blue * x_blue + min_straw * x_straw >= req_min;

% At least 3 times as many packs of strawberries as blueberries
constraint x_straw >= straw_to_blue_ratio * x_blue;

% Objective definition
constraint total_sugar = sugar_blue * x_blue + sugar_straw * x_straw;

% Objective
solve minimize total_sugar;