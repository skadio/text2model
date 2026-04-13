% Parameters (with values embedded)
int: P = 3; % products I, II, III
int: E = 3; % equipment A, B, C

set of int: Products = 1..P;
set of int: Equip = 1..E;

% Processing hours required per unit product on each equipment (A,B,C rows; I,II,III cols)
array[Equip, Products] of int: hours = array2d(Equip, Products, [
  8,  2, 10,   % Equipment A
  10, 5,  8,   % Equipment B
  2,  13, 10   % Equipment C
]);

% Effective monthly equipment hours available
array[Equip] of int: cap = [300, 400, 420];

% Unit product profit (per thousand yuan)
array[Products] of float: profit = [3.0, 2.0, 2.9];

% Variables
array[Products] of var 0..420: x; % production quantities (nonnegative); 420 is a safe upper bound

% Constraints
constraint forall(e in Equip)(
  sum(p in Products)(hours[e,p] * x[p]) <= cap[e]
);

% Objective
solve maximize sum(p in Products)(profit[p] * x[p]);