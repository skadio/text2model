% Parameters
int: labor_available = 1000;
int: inspect_available = 500;

int: labor_high = 17;
int: inspect_high = 8;
int: profit_high = 300;
int: demand_high = 50;

int: labor_mid = 10;
int: inspect_mid = 4;
int: profit_mid = 200;
int: demand_mid = 80;

int: labor_low = 2;
int: inspect_low = 2;
int: profit_low = 100;
int: demand_low = 150;

% Variables
var 0..demand_high: x_high;
var 0..demand_mid: x_mid;
var 0..demand_low: x_low;

var 0..(profit_high*demand_high + profit_mid*demand_mid + profit_low*demand_low): total_profit;

% Constraints
constraint labor_high * x_high + labor_mid * x_mid + labor_low * x_low <= labor_available;
constraint inspect_high * x_high + inspect_mid * x_mid + inspect_low * x_low <= inspect_available;

constraint total_profit =
  profit_high * x_high + profit_mid * x_mid + profit_low * x_low;

% Objective
solve maximize total_profit;