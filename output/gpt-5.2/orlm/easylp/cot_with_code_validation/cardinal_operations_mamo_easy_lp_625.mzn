% Parameters
float: c_raw = 2.0;
float: c_lab = 3.0;
float: c_prod = 1.5;
float: c_trans = 4.0;

int: min_raw_plus_lab = 500;
int: prod_le_half_raw_plus = 1000;
int: trans_ge_lab_plus = 200;

% Upper limits (not provided explicitly; set to safe large bounds consistent with constraints)
int: U_raw = 100000;
int: U_lab = 100000;
int: U_prod = 100000;
int: U_trans = 100000;

% Variables
var 0..U_raw: raw;
var 0..U_lab: lab;
var 0..U_prod: prod;
var 0..U_trans: trans;

% Constraints
constraint raw + lab >= min_raw_plus_lab;

constraint prod <= (raw div 2) + prod_le_half_raw_plus;

constraint trans >= lab + trans_ge_lab_plus;

constraint raw + prod - lab = 0;

% Objective
var float: total_cost = c_raw*raw + c_lab*lab + c_prod*prod + c_trans*trans;

solve minimize total_cost;