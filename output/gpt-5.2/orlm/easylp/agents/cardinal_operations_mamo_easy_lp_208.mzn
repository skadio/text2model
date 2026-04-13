% Parameters
int: budget = 1000;                 % Maximum total investment units across X, Y, Z

int: min_staff = 200;               % Minimum investment units for medical staff (X)
int: min_facilities = 150;          % Minimum investment units for facilities (Y)
int: min_technology = 100;          % Minimum investment units for technology (Z)

int: cost_staff = 10;               % Cost per unit invested in medical staff
int: cost_facilities = 15;          % Cost per unit invested in facilities
int: cost_technology = 20;          % Cost per unit invested in technology


% Variables
var min_staff..budget: X;           % Investment units in medical staff
var min_facilities..budget: Y;      % Investment units in facilities
var min_technology..budget: Z;      % Investment units in technology

var 0..(cost_staff*budget + cost_facilities*budget + cost_technology*budget): total_cost;
                                    % Total cost (linear expression upper-bounded safely)


% Constraints
% Budget constraint: total investment units across all areas cannot exceed the budget
constraint
  X + Y + Z <= budget;

% Minimum allocation constraints (also enforced by variable domains; kept for clarity)
constraint
  X >= min_staff;
constraint
  Y >= min_facilities;
constraint
  Z >= min_technology;

% Total cost definition
constraint
  total_cost = cost_staff * X + cost_facilities * Y + cost_technology * Z;


% Objective
solve minimize total_cost;