% Parameters
int: min_total_shifts = 10;          % Minimum total number of shifts required
int: wage_X = 8;                     % Cost per shift for type X worker
int: wage_Y = 5;                     % Cost per shift for type Y worker
int: balance_extra = 4;              % X cannot exceed 2*Y by more than this amount
int: max_total_shifts = min_total_shifts + balance_extra; % Safe upper bound on total shifts

% Variables
var 0..max_total_shifts: shifts_X;   % Number of shifts assigned to type X workers
var 0..max_total_shifts: shifts_Y;   % Number of shifts assigned to type Y workers
var 0..(wage_X*max_total_shifts + wage_Y*max_total_shifts): total_cost; % Total wage cost

% Constraints
% Total shifts coverage: ensure at least the required minimum number of shifts
constraint shifts_X + shifts_Y >= min_total_shifts;

% Workload balance: type X shifts cannot exceed twice type Y shifts by more than balance_extra
constraint shifts_X <= 2 * shifts_Y + balance_extra;

% Total cost definition: compute wage cost from assigned shifts
constraint total_cost = wage_X * shifts_X + wage_Y * shifts_Y;

% Objective
solve minimize total_cost;