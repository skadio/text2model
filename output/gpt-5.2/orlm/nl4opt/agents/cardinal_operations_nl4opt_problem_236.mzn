% Parameters
int: sandwiches_per_dine_in = 100;      % Sandwich production per dine-in store per day
int: employees_per_dine_in = 8;         % Employees required per dine-in store

int: sandwiches_per_food_truck = 50;    % Sandwich production per food-truck per day
int: employees_per_food_truck = 3;      % Employees required per food-truck

int: min_sandwiches = 500;              % Minimum required sandwiches per day
int: available_employees = 35;          % Total employees available

% Upper bounds derived from requirements and resource limits (tight and integer)
int: max_dine_in =
  min(min_sandwiches div sandwiches_per_dine_in + 5,
      available_employees div employees_per_dine_in);
int: max_food_truck =
  min(min_sandwiches div sandwiches_per_food_truck + 10,
      available_employees div employees_per_food_truck);

% Variables
var 0..max_dine_in: num_dine_in;        % Number of dine-in stores to open
var 0..max_food_truck: num_food_truck;  % Number of food-trucks to open

var 0..(max_dine_in + max_food_truck): total_stores; % Total number of stores (objective helper)

% Constraints

% Total stores definition (helper for objective)
constraint
  total_stores = num_dine_in + num_food_truck;

% Production requirement: meet at least the minimum sandwiches per day
constraint
  sandwiches_per_dine_in * num_dine_in +
  sandwiches_per_food_truck * num_food_truck >=
  min_sandwiches;

% Employee availability constraint: do not exceed available employees
constraint
  employees_per_dine_in * num_dine_in +
  employees_per_food_truck * num_food_truck <=
  available_employees;

% Objective
solve minimize total_stores;