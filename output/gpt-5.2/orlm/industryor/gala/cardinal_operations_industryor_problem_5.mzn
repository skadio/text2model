include "globals.mzn";

% Production planning with backlogging (late delivery penalties) and inventory holding cost.

%-------------------------
% Data (embedded)
%-------------------------
int: P = 3;                 % products I, II, III
int: Q = 4;                 % quarters 1..4

set of int: Products = 1..P;
set of int: Quarters = 1..Q;

% Demand[product, quarter]
array[Products, Quarters] of int: demand =
  array2d(Products, Quarters,
    [ 1500, 1000, 2000, 1200,   % Product I
      1500, 1500, 1200, 1500,   % Product II
      1000, 2000, 1500, 2500    % Product III
    ]);

array[Products] of int: hours_per_unit = [2, 4, 3];
int: cap_hours = 15000;

% End of Q4 required inventory
int: end_stock_req = 150;

% Penalty per unit per quarter of delay
array[Products] of int: late_penalty = [20, 20, 10];

% Inventory holding cost per unit per quarter (for positive stock carried)
int: hold_cost = 5;

% Product I cannot be produced in Q2
int: prodI = 1;
int: q2 = 2;

% Useful upper bounds
array[Products] of int: total_demand = [sum(q in Quarters)(demand[p,q]) | p in Products];
array[Products] of int: max_prod = [total_demand[p] + end_stock_req | p in Products];

%-------------------------
% Decision variables
%-------------------------
% Production quantity
array[Products, Quarters] of var 0..max(max_prod): prod;

% Net inventory at end of quarter: inv = stock - backlog (can be negative)
array[Products, 0..Q] of var -max(max_prod)..max(max_prod): inv;

% Split inv into positive stock and positive backlog for costing
array[Products, Quarters] of var 0..max(max_prod): stock;    % max(inv, 0)
array[Products, Quarters] of var 0..max(max_prod): backlog;  % max(-inv, 0)

%-------------------------
% Constraints
%-------------------------
% Initial inventory is zero
constraint forall(p in Products)(inv[p,0] = 0);

% Inventory balance each quarter:
% inv[p,q] = inv[p,q-1] + prod[p,q] - demand[p,q]
constraint forall(p in Products, q in Quarters)(
  inv[p,q] = inv[p,q-1] + prod[p,q] - demand[p,q]
);

% Required ending stock at end of Q4 (no backlog allowed, must be +150)
constraint forall(p in Products)(
  inv[p,Q] = end_stock_req
);

% Capacity in each quarter
constraint forall(q in Quarters)(
  sum(p in Products)(hours_per_unit[p] * prod[p,q]) <= cap_hours
);

% Product I cannot be produced in Q2
constraint prod[prodI, q2] = 0;

% Define stock/backlog from inv
constraint forall(p in Products, q in Quarters)(
  inv[p,q] = stock[p,q] - backlog[p,q]
);

%-------------------------
% Objective: holding + late penalties
% Holding cost on stock carried at end of each quarter (1..4)
% Late penalty on backlog at end of each quarter (1..4)
% (Backlog at end of Q4 will be 0 due to inv[p,4]=150, but included harmlessly.)
var int: total_holding =
  sum(p in Products, q in Quarters)(hold_cost * stock[p,q]);

var int: total_late =
  sum(p in Products, q in Quarters)(late_penalty[p] * backlog[p,q]);

var int: total_cost = total_holding + total_late;

solve minimize total_cost;

%-------------------------
% Output
%-------------------------
output [
  "Total cost = ", show(total_cost), "\n",
  "  Holding = ", show(total_holding), "\n",
  "  Late    = ", show(total_late), "\n\n",
  "Production (rows=products I..III, cols=Q1..Q4):\n",
  show([ [prod[p,q] | q in Quarters] | p in Products ]), "\n\n",
  "End-of-quarter stock (positive inventory):\n",
  show([ [stock[p,q] | q in Quarters] | p in Products ]), "\n\n",
  "End-of-quarter backlog (late deliveries):\n",
  show([ [backlog[p,q] | q in Quarters] | p in Products ]), "\n"
];