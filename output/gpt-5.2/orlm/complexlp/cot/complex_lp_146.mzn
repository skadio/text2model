% Parameters (with values embedded)
int: num_centers = 9;
int: num_stores  = 8;

set of int: Centers = 1..num_centers;
set of int: Stores  = 1..num_stores;

array[Centers] of int: open_cost =
  [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000];

array[Stores] of int: demand =
  [414, 520, 635, 780, 920, 610, 475, 560];

array[Centers] of int: capacity =
  [1030, 1450, 1280, 1625, 1500, 1190, 1962, 1400, 1550];

% Transportation costs per unit from center i to store j
array[Centers, Stores] of int: trans_cost =
[
  | 3, 4, 6, 7, 5, 8, 6, 4 |
  | 4, 5, 5, 6, 6, 7, 5, 6 |
  | 5, 4, 3, 5, 7, 6, 4, 5 |
  | 6, 6, 4, 3, 5, 5, 6, 7 |
  | 5, 7, 6, 4, 3, 4, 7, 6 |
  | 4, 6, 7, 5, 4, 3, 6, 5 |
  | 7, 5, 4, 6, 6, 5, 3, 4 |
  | 6, 7, 5, 6, 5, 6, 4, 3 |
  | 5, 6, 6, 7, 4, 5, 5, 4 |
];

% Variables
array[Centers] of var 0..1: open;
array[Centers, Stores] of var 0..max(demand): ship;

% Constraints
constraint
  forall(j in Stores) (
    sum(i in Centers)(ship[i,j]) = demand[j]
  );

constraint
  forall(i in Centers) (
    sum(j in Stores)(ship[i,j]) <= capacity[i] * open[i]
  );

% Objective
var int: total_cost =
  sum(i in Centers)(open_cost[i] * open[i]) +
  sum(i in Centers, j in Stores)(trans_cost[i,j] * ship[i,j]);

solve minimize total_cost;