% Parameters
% All data is embedded directly in the model (no .dzn expected)

int: min_risk_tol = 50000;      % Minimum required value for (2*stocks + bonds)
int: max_imbalance = 20000;     % Maximum allowed value for (stocks - 2*bonds)
int: cost_stock = 4;            % Cost per unit of stocks
int: cost_bond = 3;             % Cost per unit of bonds

% Safe finite upper bounds to keep domains bounded for the solver
int: stock_ub = 120000;
int: bond_ub  = 50000;


% Variables
var 0..stock_ub: stocks;        % Number of stock units to buy (integer, non-negative)
var 0..bond_ub:  bonds;         % Number of bond units to buy (integer, non-negative)

% Total investment cost (bounded by max possible with the above upper bounds)
var 0..(cost_stock*stock_ub + cost_bond*bond_ub): total_cost;


% Constraints
% Risk tolerance / expected return requirement:
% Combined amount in (2*stocks + bonds) must be at least the minimum threshold.
constraint 2 * stocks + bonds >= min_risk_tol;

% Portfolio balance requirement:
% The imbalance (stocks - 2*bonds) cannot exceed the maximum allowed.
constraint stocks - 2 * bonds <= max_imbalance;

% Total cost definition:
% Link total_cost to the per-unit costs and quantities purchased.
constraint total_cost = cost_stock * stocks + cost_bond * bonds;


% Objective
solve minimize total_cost;