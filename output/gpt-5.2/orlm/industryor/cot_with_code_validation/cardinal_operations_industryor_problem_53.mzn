% Parameters
int: P = 3; % products I, II, III
int: E = 3; % equipment A, B, C

set of int: Products = 1..P;
set of int: Equip = 1..E;

% hours[equipment, product]
array[Equip, Products] of int: hours =
  array2d(Equip, Products,
    [
      8,  2, 10,   % A
      10, 5, 8,    % B
      2, 13, 10    % C
    ]);

array[Equip] of int: cap = [300, 400, 420];

% profit per unit (thousand yuan)
array[Products] of float: profit = [3.0, 2.0, 2.9];

% Variables
% production quantities (units), bounded by a safe upper bound from capacities
array[Products] of var 0..210: x;

var float: total_profit;

% Constraints
constraint
  forall(e in Equip)(
    sum(p in Products)(hours[e,p] * x[p]) <= cap[e]
  );

constraint
  total_profit = sum(p in Products)(profit[p] * int2float(x[p]));

% Objective
solve maximize total_profit;