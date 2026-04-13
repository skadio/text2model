% Parameters (with values embedded)
int: raw_cost = 2;
int: labour_cost = 3;
float: prod_cost = 1.5;
int: trans_cost = 4;

int: min_raw_plus_labour = 500;
int: trans_minus_labour_min = 200;
int: prod_eff_slack = 1000;

% Upper limits (embedded; not specified numerically in the description, so set to large safe caps)
int: U_raw = 100000;
int: U_labour = 100000;
int: U_prod = 100000;
int: U_trans = 100000;

% Variables
var 0..U_raw: raw;
var 0..U_labour: labour;
var 0..U_prod: prod;
var 0..U_trans: trans;

% Auxiliary variable to keep objective linear/integer
var 0..1000000000: total_cost2; % 2 * total_cost (so all coefficients are integers)

% Constraints
constraint raw + labour >= min_raw_plus_labour;

% Production costs cannot exceed half the quantity of raw materials by more than 1000:
% prod <= raw/2 + 1000  <=>  2*prod <= raw + 2000
constraint 2 * prod <= raw + 2 * prod_eff_slack;

% Transportation costs should exceed labour hours by at least 200
constraint trans >= labour + trans_minus_labour_min;

% Balance requirement: raw + prod - labour = 0
constraint raw + prod - labour = 0;

% Objective (minimize total cost, rounded to nearest whole number)
% total_cost = 2*raw + 3*labour + 1.5*prod + 4*trans
% total_cost2 = 2*total_cost = 4*raw + 6*labour + 3*prod + 8*trans
constraint total_cost2 = 4 * raw + 6 * labour + 3 * prod + 8 * trans;

solve minimize total_cost2;

% Output minimal total cost rounded to nearest whole number:
% rounded(total_cost) = floor(total_cost + 0.5)
% total_cost = total_cost2 / 2
output [
  "raw=", show(raw), "\n",
  "labour=", show(labour), "\n",
  "prod=", show(prod), "\n",
  "trans=", show(trans), "\n",
  "total_cost_exact=", show(total_cost2), "/2\n",
  "total_cost_rounded=", show( (total_cost2 + 1) div 2 ), "\n"
];