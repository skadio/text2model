% Parameters
int: profit_phone = 120;
int: profit_laptop = 40;

int: space_phone = 1;
int: space_laptop = 4;
int: space_available = 400;

int: cost_phone = 400;
int: cost_laptop = 100;
int: budget = 6000;

int: laptop_share_num = 80;  % at least 80%
int: laptop_share_den = 100;

% Variables
var 0..space_available: phones;
var 0..(space_available div space_laptop): laptops;

var 0..(profit_phone*space_available + profit_laptop*(space_available div space_laptop)): profit;

% Constraints
constraint space_phone * phones + space_laptop * laptops <= space_available;

constraint cost_phone * phones + cost_laptop * laptops <= budget;

% laptops >= 0.8 * (phones + laptops)  <=>  100*laptops >= 80*(phones + laptops)
constraint laptop_share_den * laptops >= laptop_share_num * (phones + laptops);

constraint profit = profit_phone * phones + profit_laptop * laptops;

% Objective
solve maximize profit;