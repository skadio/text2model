% Parameters
int: costX = 20;                 % Cost per unit allocated to Project X ($/unit)
int: costY = 30;                 % Cost per unit allocated to Project Y ($/unit)

int: min_progress = 60;          % Minimum required progress units
int: max_workload = 80;          % Maximum allowed workload units
int: min_diff_X_over_Y = 10;     % Minimum required difference (X - Y)

int: lbX = 0;                    % Lower bound for X allocation
int: ubX = 1000;                 % Upper bound for X allocation
int: lbY = 0;                    % Lower bound for Y allocation
int: ubY = 500;                  % Upper bound for Y allocation

% Variables
var lbX..ubX: x;                 % Integer units allocated to Project X
var lbY..ubY: y;                 % Integer units allocated to Project Y
var 0..(costX*ubX + costY*ubY): total_cost; % Total cost in dollars

% Constraints
% Progress requirement: ensure sufficient combined progress
constraint 5 * x + 3 * y >= min_progress;

% Workload limit: prevent over-commitment
constraint 4 * x + y <= max_workload;

% Strategic focus: allocate at least min_diff_X_over_Y more units to X than Y
constraint x - y >= min_diff_X_over_Y;

% Total cost definition: link decision variables to total_cost
constraint total_cost = costX * x + costY * y;

% Objective
solve minimize total_cost;

% Optional output for clarity
output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];