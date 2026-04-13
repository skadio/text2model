% Parameters
int: total_employees = 100;                 % Total number of new hires to allocate

int: min_X = 20;                            % Minimum hires required in department X
int: min_Y = 15;                            % Minimum hires required in department Y
int: min_Z = 10;                            % Minimum hires required in department Z

int: cost_X = 50;                           % Training cost per hire in department X
int: cost_Y = 80;                           % Training cost per hire in department Y
int: cost_Z = 30;                           % Training cost per hire in department Z

% Variables
var min_X..total_employees: hires_X;         % Number of hires assigned to department X
var min_Y..total_employees: hires_Y;         % Number of hires assigned to department Y
var min_Z..total_employees: hires_Z;         % Number of hires assigned to department Z

var 0..(total_employees * max([cost_X, cost_Y, cost_Z])): total_cost; % Total training cost (bounded)

% Constraints
% Staffing balance: allocate exactly all new employees across departments
constraint
  hires_X + hires_Y + hires_Z = total_employees;

% Minimum staffing requirements (also enforced by variable domains; kept for clarity/robustness)
constraint
  hires_X >= min_X /\ hires_Y >= min_Y /\ hires_Z >= min_Z;

% Total training cost definition
constraint
  total_cost = cost_X * hires_X + cost_Y * hires_Y + cost_Z * hires_Z;

% Objective
solve minimize total_cost;