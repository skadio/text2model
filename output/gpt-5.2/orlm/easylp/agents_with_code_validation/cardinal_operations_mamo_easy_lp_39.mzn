% Parameters
int: cost_stock = 5;              % Cost per unit of stocks ($)
int: cost_bond  = 3;              % Cost per unit of bonds ($)

int: a1_stock = 2;                % Coefficient of stocks in constraint 1
int: a1_bond  = 4;                % Coefficient of bonds in constraint 1
int: rhs1     = 10000;            % Minimum required amount in constraint 1 ($)

int: a2_stock = 3;                % Coefficient of stocks in constraint 2
int: a2_bond  = -1;               % Coefficient of bonds in constraint 2 (subtracted)
int: rhs2     = 5000;             % Maximum allowed amount in constraint 2 ($)

% Upper bounds to keep variables finite (safe bounds for search)
int: max_stock = rhs2 div a2_stock;                           % with bond_units >= 0, 3*stock_units <= 5000
int: max_bond  = (rhs1 + a1_stock * max_stock) div a1_bond;   % sufficient bound for bonds

% Variables
var 0..max_stock: stock_units;    % Number of stock units (integer, nonnegative)
var 0..max_bond:  bond_units;     % Number of bond units (integer, nonnegative)

var 0..(cost_stock*max_stock + cost_bond*max_bond): total_cost; % Total cost ($), integer-bounded

% Constraints
% --- Total cost definition ---
constraint
  total_cost = cost_stock * stock_units + cost_bond * bond_units;

% --- Minimum combined investment requirement ---
% 2*stocks + 4*bonds >= 10000
constraint
  a1_stock * stock_units + a1_bond * bond_units >= rhs1;

% --- Risk/return balance upper bound ---
% 3*stocks - 1*bonds <= 5000
constraint
  a2_stock * stock_units + a2_bond * bond_units <= rhs2;

% Objective
solve minimize total_cost;