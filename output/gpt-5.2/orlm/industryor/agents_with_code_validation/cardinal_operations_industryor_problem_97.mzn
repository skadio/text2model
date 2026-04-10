% Parameters
int: steel_available = 200;          % kg of steel available
int: aluminum_available = 300;       % kg of aluminum available
int: labor_available = 300;          % regular labor hours available

int: steel_per_A = 6;                % kg steel needed per unit of A
int: aluminum_per_A = 8;             % kg aluminum needed per unit of A
int: labor_per_A = 11;               % labor hours needed per unit of A
int: profit_per_A = 5000;            % yuan profit per unit of A (excluding overtime pay)

int: steel_per_B = 12;               % kg steel needed per unit of B
int: aluminum_per_B = 20;            % kg aluminum needed per unit of B
int: labor_per_B = 24;               % labor hours needed per unit of B
int: profit_per_B = 11000;           % yuan profit per unit of B (excluding overtime pay)

int: overtime_cost_per_hour = 100;   % yuan cost per overtime hour

% Upper bounds derived from steel/aluminum resource limits (keeps variable domains finite)
int: max_A_by_steel = steel_available div steel_per_A;
int: max_A_by_aluminum = aluminum_available div aluminum_per_A;
int: max_B_by_steel = steel_available div steel_per_B;
int: max_B_by_aluminum = aluminum_available div aluminum_per_B;

int: max_A_units = min(max_A_by_steel, max_A_by_aluminum);
int: max_B_units = min(max_B_by_steel, max_B_by_aluminum);

% Variables
var 0..max_A_units: units_A;         % number of units of product A to produce
var 0..max_B_units: units_B;         % number of units of product B to produce

var 0..(labor_per_A*max_A_units + labor_per_B*max_B_units): total_labor_used;  % total labor hours used
var 0..(labor_per_A*max_A_units + labor_per_B*max_B_units): overtime_hours;    % overtime hours (beyond regular labor)

% Constraints
% Resource capacity constraints (steel and aluminum cannot exceed availability)
constraint
  steel_per_A * units_A + steel_per_B * units_B <= steel_available;

constraint
  aluminum_per_A * units_A + aluminum_per_B * units_B <= aluminum_available;

% Labor accounting: define total labor used based on production quantities
constraint
  total_labor_used = labor_per_A * units_A + labor_per_B * units_B;

% Overtime definition: overtime is the excess labor over regular labor hours (nonnegative)
constraint
  overtime_hours >= total_labor_used - labor_available;

% (Redundant due to domain, but harmless and keeps intent explicit)
constraint
  overtime_hours >= 0;

% Objective
solve maximize (profit_per_A * units_A + profit_per_B * units_B
                - overtime_cost_per_hour * overtime_hours);