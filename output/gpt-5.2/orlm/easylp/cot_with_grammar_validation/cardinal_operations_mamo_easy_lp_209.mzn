% Parameters
int: budget = 1000;

int: coefX = 50;
int: coefY = 30;
int: coefZ = 20;

int: x_more_than_2y = 200;   % X >= 2*Y + 200
int: z_more_than_y = 150;    % Z >= Y + 150

int: lbX = 0;
int: ubX = budget;
int: lbY = 0;
int: ubY = budget;
int: lbZ = 0;
int: ubZ = budget;

% Variables
var lbX..ubX: X;
var lbY..ubY: Y;
var lbZ..ubZ: Z;

var 0..(coefX*ubX + coefY*ubY + coefZ*ubZ): total_cost;

% Constraints
constraint X + Y + Z <= budget;

constraint X >= 2*Y + x_more_than_2y;
constraint Z >= Y + z_more_than_y;

constraint total_cost = coefX*X + coefY*Y + coefZ*Z;

% Objective
solve minimize total_cost;