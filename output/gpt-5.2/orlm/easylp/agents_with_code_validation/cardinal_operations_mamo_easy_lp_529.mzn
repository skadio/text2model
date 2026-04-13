% Parameters
int: budget_limit = 2000;                 % Total allocation budget
int: min_balance = 500;                  % Minimum required value for (2*x1 - 0.5*x2)
int: max_diff = 1000;                    % Maximum allowed value for (x3 - 0.8*x1)

int: cost_inventory = 5;                 % Cost per unit for inventory (x1)
int: cost_advertising = 3;               % Cost per unit for advertising (x2)
int: cost_customer_service = 7;          % Cost per unit for customer service (x3)

int: max_inventory = 1500;               % Upper bound for inventory allocation
int: max_advertising = 800;              % Upper bound for advertising allocation
int: max_customer_service = 1200;        % Upper bound for customer service allocation

% Variables
var 0..max_inventory: x1;                % Inventory allocation (integer, non-negative)
var 0..max_advertising: x2;              % Advertising allocation (integer, non-negative)
var 0..max_customer_service: x3;         % Customer service allocation (integer, non-negative)

var 0..(cost_inventory*max_inventory
      + cost_advertising*max_advertising
      + cost_customer_service*max_customer_service): total_cost;  % Total cost to minimize

% Constraints
% Budget constraint: total allocation across departments cannot exceed budget_limit
constraint x1 + x2 + x3 <= budget_limit;

% Operational balance constraint:
% 2*x1 - 0.5*x2 >= min_balance
% Avoid fractions by multiplying through by 2: 4*x1 - x2 >= 2*min_balance
constraint 4 * x1 - x2 >= 2 * min_balance;

% Customer service vs inventory difference constraint:
% (x3 - 0.8*x1) <= max_diff
% Avoid decimals by multiplying through by 10: 10*x3 - 8*x1 <= 10*max_diff
constraint 10 * x3 - 8 * x1 <= 10 * max_diff;

% Total cost definition
constraint
  total_cost = cost_inventory * x1
             + cost_advertising * x2
             + cost_customer_service * x3;

% Objective
solve minimize total_cost;

output [
  "x1 (inventory) = ", show(x1), "\n",
  "x2 (advertising) = ", show(x2), "\n",
  "x3 (customer service) = ", show(x3), "\n",
  "total_cost = ", show(total_cost), "\n"
];