% Parameters
int: Q = 4;                              % number of quarters
set of int: QUARTERS = 1..Q;

array[QUARTERS] of int: demand = [40, 60, 75, 25];   % demand per quarter
int: initial_inventory = 10;                          % inventory at start of quarter 1

int: regular_cap = 40;                   % max regular-time production per quarter
int: regular_cost = 400;                 % cost per regular-time unit
int: overtime_cost = 450;                % cost per overtime unit
int: holding_cost = 20;                  % holding cost per unit at end of each quarter


% Variables
array[QUARTERS] of var 0..regular_cap: prod_regular;  % regular production in quarter q
array[QUARTERS] of var 0..1000: prod_overtime;        % overtime production in quarter q (large upper bound)

array[0..Q] of var 0..1000: inventory;                % end-of-quarter inventory; inventory[0]=initial

var int: total_cost;                                  % total production + holding cost


% Constraints

% --- Inventory initialization (starting inventory before quarter 1) ---
constraint inventory[0] = initial_inventory;

% --- Inventory balance and on-time demand satisfaction (per quarter) ---
% After producing in quarter q, demand[q] must be met, leaving end inventory[q].
constraint
  forall(q in QUARTERS) (
    inventory[q] = inventory[q-1] + prod_regular[q] + prod_overtime[q] - demand[q]
  );

% --- Nonnegativity / feasibility via inventory domain (no backlogging) ---
constraint
  forall(q in QUARTERS) (
    inventory[q] >= 0
  );

% --- Total cost definition (production + end-of-quarter holding) ---
constraint
  total_cost =
    sum(q in QUARTERS) (
        regular_cost  * prod_regular[q]
      + overtime_cost * prod_overtime[q]
      + holding_cost  * inventory[q]
    );


% Objective
solve minimize total_cost;