% Minimum cost diet problem (hamburgers and chicken wraps)
% All data embedded in the model.

int: cal_req = 2200;
int: prot_req = 50;
int: carb_req = 70;

int: cal_h = 800;
int: prot_h = 19;
int: carb_h = 20;
int: cost_h_cents = 650;   % $6.50

int: cal_w = 450;
int: prot_w = 12;
int: carb_w = 10;
int: cost_w_cents = 400;   % $4.00

% Decision variables: number of each item (nonnegative integers)
var 0..20: hamburgers;
var 0..20: wraps;

constraint cal_h * hamburgers + cal_w * wraps >= cal_req;
constraint prot_h * hamburgers + prot_w * wraps >= prot_req;
constraint carb_h * hamburgers + carb_w * wraps >= carb_req;

var int: total_cost_cents = cost_h_cents * hamburgers + cost_w_cents * wraps;

solve minimize total_cost_cents;

output [
  "Hamburgers = ", show(hamburgers), "\n",
  "Wraps      = ", show(wraps), "\n",
  "Total cost (cents) = ", show(total_cost_cents), "\n",
  "Total cost ($) = ", show(total_cost_cents div 100), ".", 
    if (total_cost_cents mod 100) < 10 then "0" else "" endif,
    show(total_cost_cents mod 100), "\n",
  "Totals: calories=", show(cal_h*hamburgers + cal_w*wraps),
  ", protein=", show(prot_h*hamburgers + prot_w*wraps),
  ", carbs=", show(carb_h*hamburgers + carb_w*wraps), "\n"
];