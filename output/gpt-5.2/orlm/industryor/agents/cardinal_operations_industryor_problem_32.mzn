% Parameters
% Number of distinct item groups (dogs must stay together; diamonds can be split as 3 identical items)
int: n = 11;
set of int: ITEMS = 1..n;

% Item values (in dollars), aligned with ITEMS index order below
% 1 Painting, 2 Bust, 3 Vase, 4 Porsche, 5 Diamonds (3x), 6 Sofa,
% 7 Dogs (2 together), 8 Sculpture, 9 Boat, 10 Motorcycle, 11 Cavour furniture
array[ITEMS] of int: value = [
  25000,  5000, 20000, 40000, 36000,
   3000,  6000, 10000, 15000, 10000, 13000
];

% Multiplicity: how many identical units are available for each item group
% (only diamonds are splittable into 3 units; all others are single units;
% dogs are a single inseparable bundle of 2 dogs)
array[ITEMS] of int: qty = [
  1, 1, 1, 1, 3,
  1, 1, 1, 1, 1, 1
];

% Per-unit value for each group (diamonds become 12000 each; others unchanged)
array[ITEMS] of int: unit_value = [ value[i] div qty[i] | i in ITEMS ];

% Variables
% x[i] = number of units of item i assigned to son 1 (rest goes to son 2)
array[ITEMS] of var 0..max(qty): x;

% Total values assigned to each son
var int: total1;
var int: total2;

% Absolute difference in total values (objective variable)
var int: diff;


% Constraints

% --- Domain constraints: allocation counts must be feasible w.r.t. multiplicities
constraint
  forall(i in ITEMS) (
    x[i] >= 0 /\ x[i] <= qty[i]
  );

% --- Total value computation for each son
constraint
  total1 = sum(i in ITEMS) ( x[i] * unit_value[i] );

constraint
  total2 = sum(i in ITEMS) ( (qty[i] - x[i]) * unit_value[i] );

% --- Absolute difference definition
constraint
  diff = abs(total1 - total2);


% Objective
solve minimize diff;