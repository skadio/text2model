% Parameters
% Unit costs
int: cost_stock = 5;
int: cost_bond  = 3;

% Constraint coefficients and RHS values
int: a1_stock = 2;
int: a1_bond  = 4;
int: rhs1     = 10000;   % 2*stocks + 4*bonds >= 10000

int: a2_stock = 3;
int: a2_bond  = -1;      % 3*stocks - bonds <= 5000
int: rhs2     = 5000;

% Simple safe upper bounds for search (given non-negativity)
int: max_stock = 5000;
int: max_bond  = 2500;


% Variables
% Decision variables: whole units of assets (non-negative integers)
var 0..max_stock: stocks;
var 0..max_bond:  bonds;

% Total cost
var 0..(cost_stock*max_stock + cost_bond*max_bond): total_cost;

% Link total cost to decisions
constraint total_cost = cost_stock * stocks + cost_bond * bonds;


% Constraints
% --- Investment requirement (minimum combined allocation) ---
% 2*stocks + 4*bonds >= 10000
constraint a1_stock * stocks + a1_bond * bonds >= rhs1;

% --- Risk/return balance constraint ---
% 3*stocks - bonds <= 5000
constraint a2_stock * stocks + a2_bond * bonds <= rhs2;


% Objective
solve minimize total_cost;