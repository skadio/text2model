% Parameters
float: raw_cost_per_lb = 3.0;
int: raw_max_lb = 4000;

int: lab_hours_available = 6000;

int: reg_brute_oz_per_lb = 3;
int: reg_chanelle_oz_per_lb = 4;

float: price_reg_brute = 7.0;
float: price_reg_chanelle = 6.0;
float: price_lux_brute = 18.0;
float: price_lux_chanelle = 14.0;

int: lab_hours_per_lb_raw = 1;

int: lab_hours_per_oz_lux_brute = 3;
int: lab_hours_per_oz_lux_chanelle = 2;

float: extra_proc_cost_per_oz_lux = 4.0;

% Upper bounds implied by raw capacity
int: reg_brute_max_oz = reg_brute_oz_per_lb * raw_max_lb;        % 12000
int: reg_chanelle_max_oz = reg_chanelle_oz_per_lb * raw_max_lb;  % 16000

% Variables
var 0..raw_max_lb: raw_lb;

var 0..reg_brute_max_oz: reg_brute_oz;
var 0..reg_chanelle_max_oz: reg_chanelle_oz;

var 0..reg_brute_max_oz: lux_brute_oz;
var 0..reg_chanelle_max_oz: lux_chanelle_oz;

% Constraints
constraint reg_brute_oz = reg_brute_oz_per_lb * raw_lb;
constraint reg_chanelle_oz = reg_chanelle_oz_per_lb * raw_lb;

constraint lux_brute_oz <= reg_brute_oz;
constraint lux_chanelle_oz <= reg_chanelle_oz;

constraint
  lab_hours_per_lb_raw * raw_lb
+ lab_hours_per_oz_lux_brute * lux_brute_oz
+ lab_hours_per_oz_lux_chanelle * lux_chanelle_oz
<= lab_hours_available;

% Objective
var float: profit =
  % Revenue: sell remaining regular + luxury (lux uses up regular 1:1)
  price_reg_brute * (reg_brute_oz - lux_brute_oz)
+ price_reg_chanelle * (reg_chanelle_oz - lux_chanelle_oz)
+ price_lux_brute * lux_brute_oz
+ price_lux_chanelle * lux_chanelle_oz
  % Costs: raw + extra processing for luxury
- raw_cost_per_lb * raw_lb
- extra_proc_cost_per_oz_lux * (lux_brute_oz + lux_chanelle_oz);

solve maximize profit;