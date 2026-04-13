% Parameters
float: cost_raw = 2.0;
float: cost_labour = 3.0;
float: cost_prod = 1.5;
float: cost_trans = 4.0;

int: min_raw_plus_labour = 500;
int: prod_eff_offset = 1000;
int: min_trans_minus_labour = 200;

% Upper limits (not provided explicitly; set to safe large bounds)
int: U_raw = 100000;
int: U_labour = 100000;
int: U_prod = 100000;
int: U_trans = 100000;

% Variables
var 0..U_raw: raw;
var 0..U_labour: labour;
var 0..U_prod: prod;
var 0..U_trans: trans;

% Cost scaled by 2 to avoid fractions: minimize 2*cost
% 2*total_cost = 4*raw + 6*labour + 3*prod + 8*trans
var 0..(4*U_raw + 6*U_labour + 3*U_prod + 8*U_trans): total_cost_x2;

% Constraints
constraint raw + labour >= min_raw_plus_labour;

constraint prod <= (raw div 2) + prod_eff_offset;

constraint trans - labour >= min_trans_minus_labour;

constraint raw + prod - labour = 0;

constraint total_cost_x2 = 4*raw + 6*labour + 3*prod + 8*trans;

% Objective
solve minimize total_cost_x2;