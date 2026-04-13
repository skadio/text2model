% Minimum-cost diet: hamburgers and chicken wraps
% Data embedded as requested.

include "globals.mzn";

% Nutrition requirements
int: minCalories = 2200;
int: minProtein  = 50;
int: minCarbs    = 70;

% Item data
int: cal_h = 800;   int: prot_h = 19;  int: carb_h = 20;   % hamburger
int: cal_w = 450;   int: prot_w = 12;  int: carb_w = 10;   % chicken wrap

% Costs in cents to avoid floating point
int: cost_h = 650;  % $6.50
int: cost_w = 400;  % $4.00

% Decision variables: number of each item (nonnegative integers)
% Upper bounds: enough to cover the strictest requirement alone
int: maxH = max([ceil(minCalories / float(cal_h)),
                 ceil(minProtein  / float(prot_h)),
                 ceil(minCarbs    / float(carb_h))]);
int: maxW = max([ceil(minCalories / float(cal_w)),
                 ceil(minProtein  / float(prot_w)),
                 ceil(minCarbs    / float(carb_w))]);

var 0..maxH: hamburgers;
var 0..maxW: wraps;

% Constraints: meet or exceed all nutrition requirements
constraint cal_h * hamburgers + cal_w * wraps >= minCalories;
constraint prot_h * hamburgers + prot_w * wraps >= minProtein;
constraint carb_h * hamburgers + carb_w * wraps >= minCarbs;

% Objective: minimize total cost
var 0..(cost_h * maxH + cost_w * maxW): totalCostCents;
constraint totalCostCents = cost_h * hamburgers + cost_w * wraps;

solve minimize totalCostCents;

output [
  "Hamburgers = ", show(hamburgers), "\n",
  "Wraps      = ", show(wraps), "\n",
  "Total cost = $", show(totalCostCents div 100), ".", 
                   if totalCostCents mod 100 < 10 then "0" else "" endif,
                   show(totalCostCents mod 100), "\n",
  "Calories   = ", show(cal_h * hamburgers + cal_w * wraps), "\n",
  "Protein    = ", show(prot_h * hamburgers + prot_w * wraps), "\n",
  "Carbs      = ", show(carb_h * hamburgers + carb_w * wraps), "\n"
];