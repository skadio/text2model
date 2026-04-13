% Parameters
float: c_raw = 2.0;
float: c_lab = 3.0;
float: c_prod = 1.5;
float: c_trans = 4.0;

int: min_raw_plus_lab = 500;
int: trans_minus_lab_min = 200;
int: prod_le_raw_over_2_plus = 1000;

% Upper limits are not specified in the description; use non-negative allocations only.
int: UB = 1000000;

% Variables
var 0..UB: raw;
var 0..UB: lab;
var 0..UB: prod;
var 0..UB: trans;

var float: total_cost;

% Constraints
constraint raw + lab >= min_raw_plus_lab;

constraint prod <= (raw div 2) + prod_le_raw_over_2_plus;

constraint trans >= lab + trans_minus_lab_min;

constraint raw + prod - lab = 0;

constraint total_cost = c_raw * raw + c_lab * lab + c_prod * prod + c_trans * trans;

% Objective
solve minimize total_cost;