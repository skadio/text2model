% Parameters
int: lab_hours_available = 6000;
int: raw_lb_max = 4000;

int: raw_cost_per_lb = 3;
int: base_lab_hours_per_lb = 1;

int: brute_reg_yield_oz_per_lb = 3;
int: chanelle_reg_yield_oz_per_lb = 4;

int: price_brute_reg_per_oz = 7;
int: price_chanelle_reg_per_oz = 6;

int: price_brute_lux_per_oz = 18;
int: price_chanelle_lux_per_oz = 14;

int: brute_lux_extra_hours_per_oz = 3;
int: chanelle_lux_extra_hours_per_oz = 2;

int: lux_processing_cost_per_oz = 4;

% Upper bounds for variables (derived from maximum raw purchase)
int: reg_brute_oz_max = brute_reg_yield_oz_per_lb * raw_lb_max;      % 12000
int: reg_chanelle_oz_max = chanelle_reg_yield_oz_per_lb * raw_lb_max; % 16000

% Variables
var 0..raw_lb_max: raw_lb;

var 0..reg_brute_oz_max: reg_brute_oz;
var 0..reg_chanelle_oz_max: reg_chanelle_oz;

var 0..reg_brute_oz_max: lux_brute_oz;
var 0..reg_chanelle_oz_max: lux_chanelle_oz;

var 0..reg_brute_oz_max: sold_reg_brute_oz;
var 0..reg_chanelle_oz_max: sold_reg_chanelle_oz;

var int: profit;

% Constraints
constraint
  reg_brute_oz = brute_reg_yield_oz_per_lb * raw_lb;

constraint
  reg_chanelle_oz = chanelle_reg_yield_oz_per_lb * raw_lb;

constraint
  sold_reg_brute_oz + lux_brute_oz = reg_brute_oz;

constraint
  sold_reg_chanelle_oz + lux_chanelle_oz = reg_chanelle_oz;

constraint
  base_lab_hours_per_lb * raw_lb
  + brute_lux_extra_hours_per_oz * lux_brute_oz
  + chanelle_lux_extra_hours_per_oz * lux_chanelle_oz
  <= lab_hours_available;

% Objective
constraint
  profit =
    price_brute_reg_per_oz * sold_reg_brute_oz
  + price_chanelle_reg_per_oz * sold_reg_chanelle_oz
  + price_brute_lux_per_oz * lux_brute_oz
  + price_chanelle_lux_per_oz * lux_chanelle_oz
  - raw_cost_per_lb * raw_lb
  - lux_processing_cost_per_oz * (lux_brute_oz + lux_chanelle_oz);

solve maximize profit;