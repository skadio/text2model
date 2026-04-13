% Parameters
% Total available investment budget (in dollars)
int: total_investment = 20000;

% Minimum required value for 3*stocks + 2*bonds (in dollars)
int: min_weighted_value = 10000;

% Maximum allowed absolute difference between stocks and bonds (in dollars)
int: max_difference = 5000;

% Cost per unit (in dollars)
int: cost_stock = 10;
int: cost_bond  = 5;

% Variables
% Whole-number investments (in dollars)
var 0..total_investment: invest_stock; % amount invested in stocks
var 0..total_investment: invest_bond;  % amount invested in bonds

% Total cost to minimize (in dollars)
var 0..(cost_stock*total_investment + cost_bond*total_investment): total_cost;

% Constraints
% Budget allocation: invest the entire available amount between stocks and bonds
constraint invest_stock + invest_bond = total_investment;

% Diversification / weighted value requirement: 3*stocks + 2*bonds must reach minimum
constraint 3 * invest_stock + 2 * invest_bond >= min_weighted_value;

% Risk control: absolute difference between stock and bond investments is bounded
constraint abs(invest_stock - invest_bond) <= max_difference;

% Total cost definition based on per-unit costs
constraint total_cost = cost_stock * invest_stock + cost_bond * invest_bond;

% Objective
solve minimize total_cost;

% (Optional) Output for inspection
output [
  "invest_stock = ", show(invest_stock), "\n",
  "invest_bond  = ", show(invest_bond), "\n",
  "total_cost   = ", show(total_cost), "\n"
];