% Parameters
% Total available investment budget (in dollars)
int: total_budget = 20000;

% Unit costs (in dollars per unit)
int: stock_unit_cost = 10;
int: bond_unit_cost  = 5;

% Diversification constraint parameters:
% 3*stocks + 2*bonds must be at least this amount (in dollars)
int: min_weighted_investment = 10000;

% Absolute difference between stock and bond investments (in dollars) cannot exceed this
int: max_investment_difference = 5000;


% Variables
% Decision variables: integer dollars invested in each option (whole numbers)
var 0..total_budget: stock_investment;
var 0..total_budget: bond_investment;

% Total cost to minimize (in dollars)
% Upper bound: investing all budget in the more expensive unit cost
var 0..(max(stock_unit_cost, bond_unit_cost) * total_budget): total_cost;


% Constraints
% Budget allocation constraint: invest the full available budget across stocks and bonds
constraint stock_investment + bond_investment = total_budget;

% Diversification / weighted investment constraint: 3*stocks + 2*bonds must meet minimum
constraint 3 * stock_investment + 2 * bond_investment >= min_weighted_investment;

% Risk / balance constraint: absolute difference between stock and bond investments bounded
constraint abs(stock_investment - bond_investment) <= max_investment_difference;

% Total cost definition constraint: compute cost from unit costs and investment amounts
constraint total_cost = stock_unit_cost * stock_investment + bond_unit_cost * bond_investment;


% Objective
solve minimize total_cost;