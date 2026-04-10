% Production planning with backlogging (late delivery penalty) and inventory holding cost
% Data embedded from the problem statement.

int: P = 3;
int: Q = 4;

set of int: Products = 1..P;
set of int: Quarters = 1..Q;

% Product indices: 1=I, 2=II, 3=III

array[Products, Quarters] of int: demand =
[| 1500, 1000, 2000, 1200  % I
 | 1500, 1500, 1200, 1500  % II
 | 1000, 2000, 1500, 2500  % III
 |];

array[Products] of int: hours_per_unit = [2, 4, 3];
int: hours_capacity_per_quarter = 15000;

array[Products] of int: init_inventory = [0, 0, 0];
array[Products] of int: final_inventory_req = [150, 150, 150];

% Penalty per unit per quarter of delay (backlog)
array[Products] of int: delay_penalty = [20, 20, 10];

% Inventory holding cost per unit per quarter
int: hold_cost = 5;

% Decision variables:
% x[p,q] = units of product p produced in quarter q
array[Products, Quarters] of var 0..100000: x;

% inv[p,q] = end-of-quarter inventory (nonnegative)
array[Products, Quarters] of var 0..100000: inv;

% back[p,q] = end-of-quarter backlog (undelivered demand accumulated), nonnegative
array[Products, Quarters] of var 0..100000: back;

% Flow balance per product and quarter:
% inv_{t-1} - back_{t-1} + production - demand_t = inv_t - back_t
constraint
  forall(p in Products, t in Quarters) (
    (if t = 1 then init_inventory[p] else inv[p, t-1] endif)
    - (if t = 1 then 0 else back[p, t-1] endif)
    + x[p, t]
    - demand[p, t]
    = inv[p, t] - back[p, t]
  );

% Production capacity per quarter
constraint
  forall(t in Quarters) (
    sum(p in Products)( hours_per_unit[p] * x[p, t] ) <= hours_capacity_per_quarter
  );

% Equipment change: Product I cannot be produced in quarter 2
constraint x[1, 2] = 0;

% Required ending inventory by end of quarter 4 (and no backlog at end)
constraint forall(p in Products) (
  inv[p, Q] >= final_inventory_req[p] /\ back[p, Q] = 0
);

% Objective: minimize inventory holding + delay (backlog) penalty
var int: total_cost =
  sum(p in Products, t in Quarters)( hold_cost * inv[p, t] + delay_penalty[p] * back[p, t] );

solve minimize total_cost;

output [
  "Total cost = ", show(total_cost), "\n\n",
  "Production x[p,t] (p=1:I,2:II,3:III; t=1..4):\n",
  concat([ "p=" ++ show(p) ++ ": " ++
           concat([ show(x[p,t]) ++ (if t<Q then " " else "" endif) | t in Quarters ])
           ++ "\n"
         | p in Products ]),
  "\nEnd inventory inv[p,t]:\n",
  concat([ "p=" ++ show(p) ++ ": " ++
           concat([ show(inv[p,t]) ++ (if t<Q then " " else "" endif) | t in Quarters ])
           ++ "\n"
         | p in Products ]),
  "\nEnd backlog back[p,t]:\n",
  concat([ "p=" ++ show(p) ++ ": " ++
           concat([ show(back[p,t]) ++ (if t<Q then " " else "" endif) | t in Quarters ])
           ++ "\n"
         | p in Products ])
];