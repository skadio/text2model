% Parameters
int: steel_avail = 200;
int: alum_avail  = 300;
int: labor_avail = 300;

int: steel_A = 6;
int: alum_A  = 8;
int: labor_A = 11;
int: profit_A = 5000;

int: steel_B = 12;
int: alum_B  = 20;
int: labor_B = 24;
int: profit_B = 11000;

int: overtime_cost = 100;

% Variables
var 0..max(0, steel_avail div steel_A): xA;
var 0..max(0, steel_avail div steel_B): xB;

var 0..(labor_A * (steel_avail div steel_A) + labor_B * (steel_avail div steel_B)): labor_used;
var 0..(labor_A * (steel_avail div steel_A) + labor_B * (steel_avail div steel_B)): overtime;

var int: profit;

% Constraints
constraint steel_A * xA + steel_B * xB <= steel_avail;
constraint alum_A  * xA + alum_B  * xB <= alum_avail;

constraint labor_used = labor_A * xA + labor_B * xB;
constraint overtime >= labor_used - labor_avail;
constraint overtime >= 0;

constraint profit = profit_A * xA + profit_B * xB - overtime_cost * overtime;

% Objective
solve maximize profit;