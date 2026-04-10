% Parameters
int: cost_stock = 5;
int: cost_bond  = 3;

int: a1_stock = 2;
int: a1_bond  = 4;
int: rhs1     = 10000;   % at least

int: a2_stock = 3;
int: a2_bond  = -1;      % 3*stock - 1*bond
int: rhs2     = 5000;    % at most

% Upper bounds derived from constraints:
% From 2s + 4b >= 10000 with b >= 0 -> s <= 5000
% From 3s - b <= 5000 with b >= 0 -> s <= 1666
int: UB_stock = 1666;
% From 2s + 4b >= 10000 with s >= 0 -> b <= 2500 is NOT implied; but for minimization,
% b need not exceed 2500 because b=2500, s=0 already satisfies first constraint.
int: UB_bond  = 2500;

% Variables
var 0..UB_stock: stock;
var 0..UB_bond: bond;

var 0..(cost_stock*UB_stock + cost_bond*UB_bond): total_cost;

% Constraints
constraint total_cost = cost_stock * stock + cost_bond * bond;

constraint a1_stock * stock + a1_bond * bond >= rhs1;
constraint a2_stock * stock + a2_bond * bond <= rhs2;

% Objective
solve minimize total_cost;