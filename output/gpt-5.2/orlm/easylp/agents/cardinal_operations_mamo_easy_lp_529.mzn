% Parameters

% Total budget (upper bound on total allocation)
int: total_budget = 2000;

% Department-specific allocation upper bounds
int: max_inventory = 1500;
int: max_advertising = 800;
int: max_customer_service = 1200;

% Cost per unit allocation in each department
int: cost_inventory = 5;
int: cost_advertising = 3;
int: cost_customer_service = 7;

% Operational constraint constants
int: min_balance = 500;          % for: 2*x1 - 0.5*x2 >= 500 (scaled later)
int: max_difference = 1000;      % for: x3 - 0.8*x1 <= 1000  (scaled later)


% Variables

% Resource allocations (must be whole numbers)
var 0..max_inventory: x1;                % inventory allocation
var 0..max_advertising: x2;              % advertising allocation
var 0..max_customer_service: x3;         % customer service allocation

% Total cost (bounded using max allocations)
var 0..(cost_inventory*max_inventory
      + cost_advertising*max_advertising
      + cost_customer_service*max_customer_service): total_cost;


% Constraints

% Budget constraint: total allocation across departments cannot exceed total_budget
constraint
  x1 + x2 + x3 <= total_budget;

% Operational balance constraint:
% 2*x1 - 0.5*x2 >= min_balance
% Scale by 2 to avoid non-integer coefficients: 4*x1 - x2 >= 2*min_balance
constraint
  4*x1 - x2 >= 2 * min_balance;

% Operational difference constraint:
% x3 - 0.8*x1 <= max_difference
% Scale by 5 to avoid non-integer coefficients: 5*x3 - 4*x1 <= 5*max_difference
constraint
  5*x3 - 4*x1 <= 5 * max_difference;

% Total cost definition
constraint
  total_cost = cost_inventory * x1
             + cost_advertising * x2
             + cost_customer_service * x3;


% Objective
solve minimize total_cost;