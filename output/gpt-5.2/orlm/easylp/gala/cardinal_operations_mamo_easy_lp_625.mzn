include "globals.mzn";

% ---- Data embedded from description ----
% Costs (units per allocation unit)
float: c_raw   = 2.0;
float: c_lab   = 3.0;
float: c_prod  = 1.5;
float: c_trans = 4.0;

% No explicit upper limits were provided in the prompt.
% We choose safe finite upper bounds implied by constraints to keep the model bounded.
int: RAW_UB   = 10000;
int: LAB_UB   = 10000;
int: PROD_UB  = 10000;
int: TRANS_UB = 10000;

% ---- Decision variables (whole numbers) ----
var 0..RAW_UB:   raw;
var 0..LAB_UB:   labour;
var 0..PROD_UB:  prod;
var 0..TRANS_UB: trans;

% ---- Constraints ----
% Minimum productivity threshold
constraint raw + labour >= 500;

% Production costs cannot exceed half the quantity of raw materials by more than 1000
% i.e., prod <= 0.5*raw + 1000  ->  2*prod <= raw + 2000
constraint 2 * prod <= raw + 2000;

% Transportation costs exceed labour hours by at least 200
constraint trans >= labour + 200;

% Balance requirement: raw + prod - labour = 0
constraint raw + prod - labour = 0;

% ---- Objective ----
var float: total_cost = c_raw * raw + c_lab * labour + c_prod * prod + c_trans * trans;
solve minimize total_cost;

% ---- Output (rounded to nearest whole number) ----
output [
  "raw=", show(raw), "\n",
  "labour=", show(labour), "\n",
  "prod=", show(prod), "\n",
  "trans=", show(trans), "\n",
  "total_cost=", show(total_cost), "\n",
  "rounded_total_cost=", show(round(total_cost)), "\n"
];