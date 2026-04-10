% Two-product profit maximization with assembly overtime.
% Reformulated to avoid float linear constraints in Gecode by scaling to integers.

%--------------------------
% Data (scaled to integers)
%--------------------------
% Time scaling: use 24ths of an hour so all times are integers
int: T = 24;

% Assembly hours: 90 regular + up to 50 overtime => in 24ths
int: assembly_regular = 90 * T;     % 2160
int: assembly_overtime_max = 50 * T; % 1200

% Testing hours: 80 => in 24ths
int: testing_limit = 80 * T;        % 1920

% Per-unit time in 24ths of an hour
% Product 1: assembly 1/4=6/24, testing 1/8=3/24
% Product 2: assembly 1/3=8/24, testing 1/3=8/24
array[1..2] of int: assembly_per_unit = [6, 8];
array[1..2] of int: testing_per_unit  = [3, 8];

% Money scaling: use 10ths of a dollar to keep material costs integral
int: M = 10;

% Profit per unit excluding overtime (value - materials), in tenths of dollars
% P1: (9.0-1.2)=7.8 => 78
% P2: (8.0-0.9)=7.1 => 71
array[1..2] of int: unit_margin = [78, 71];

% Overtime cost: $7/hour => 70 tenths per hour.
% Convert to tenths per (1/24) hour: 70 / 24, handled by integer division at objective.
int: overtime_cost_per_hour_tenths = 70;

%--------------------------
% Decision variables
%--------------------------
array[1..2] of var 0..100000: units;                % produced units (integers)
var 0..assembly_overtime_max: assembly_overtime;    % overtime in 24ths of an hour (integer)

% Objective in tenths of dollars (integer)
var int: profit_tenths;

%--------------------------
% Constraints
%--------------------------
constraint
  sum(p in 1..2)(assembly_per_unit[p] * units[p]) <= assembly_regular + assembly_overtime;

constraint
  sum(p in 1..2)(testing_per_unit[p] * units[p]) <= testing_limit;

% Profit in tenths of dollars:
% revenue margin - overtime cost
% Overtime cost in tenths = 70 * (assembly_overtime / 24)
% Use integer division (div) because we only need nearest dollar in the end.
constraint
  profit_tenths =
    sum(p in 1..2)(unit_margin[p] * units[p])
    - overtime_cost_per_hour_tenths * (assembly_overtime div T);

solve maximize profit_tenths;

% Rounded to nearest dollar:
% dollars = profit_tenths / 10, rounded => (profit_tenths + 5) div 10
output [
  "units1=", show(units[1]), "\n",
  "units2=", show(units[2]), "\n",
  "overtime_hours=", show(assembly_overtime div T), "\n",
  "profit_rounded_dollars=", show((profit_tenths + 5) div 10), "\n"
];