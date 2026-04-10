include "globals.mzn";

% Diet requirements (minimums)
int: req_protein = 91;
int: req_carbs   = 136;
int: req_cal     = 1563;

% Food items
int: n = 8;
set of int: FOODS = 1..n;

array[FOODS] of string: name =
  ["Chicken breast","Tofu","Spinach","Beef steak","Eggs","Brown rice","Bananas","Quinoa"];

array[FOODS] of int: cost    = [7,7,1,9,6,7,2,6];
array[FOODS] of int: protein = [12,10,11,8,16,4,4,4];
array[FOODS] of int: carbs   = [5,1,30,26,9,25,16,20];
array[FOODS] of int: cal     = [231,210,295,211,232,146,255,205];

% Decision: number of servings of each food (nonnegative integers)
% Safe upper bound based on calories (min calories is 146)
int: maxServ = 20;
array[FOODS] of var 0..maxServ: x;

% Totals
var int: tot_protein = sum(i in FOODS)(protein[i] * x[i]);
var int: tot_carbs   = sum(i in FOODS)(carbs[i]   * x[i]);
var int: tot_cal     = sum(i in FOODS)(cal[i]     * x[i]);

% Meet requirements
constraint tot_protein >= req_protein;
constraint tot_carbs   >= req_carbs;
constraint tot_cal     >= req_cal;

% Objective: minimize total cost
var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize total_cost;

output [
  show(total_cost)
];