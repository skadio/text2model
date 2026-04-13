% Product mix profit maximization with optional overtime assembly
% All data embedded as requested.

% Data (scaled to avoid fractions)
% Time coefficients in 1/24 hours:
% Type1: assembly 1/4=6/24, testing 1/8=3/24
% Type2: assembly 1/3=8/24, testing 1/3=8/24
int: A1 = 6;
int: T1 = 3;
int: A2 = 8;
int: T2 = 8;

% Capacity (in 1/24 hours)
int: assembly_regular = 90 * 24;
int: assembly_overtime_max = 50 * 24;
int: testing_max = 80 * 24;

% Money (in cents)
int: value1 = 900;
int: value2 = 800;
int: raw1 = 120;
int: raw2 = 90;
int: overtime_cost_per_hour = 900; % $9/hour
% Convert overtime cost to cents per 1/24 hour
int: overtime_cost_per_unit = overtime_cost_per_hour div 24; % 900/24 = 37.5 not integer

% Since 900/24 is not an integer, scale money by 2 to keep integers.
% Use "half-cent" units: 1 = $0.005
int: M = 2;

int: value1M = value1 * M;
int: value2M = value2 * M;
int: raw1M = raw1 * M;
int: raw2M = raw2 * M;

int: overtime_cost_per_hourM = overtime_cost_per_hour * M; % 1800
int: overtime_cost_per_unitM = overtime_cost_per_hourM div 24; % 1800/24 = 75 exact

% Decision variables
var 0..10000: x1;  % units of product type 1
var 0..10000: x2;  % units of product type 2
var 0..assembly_overtime_max: ot; % overtime assembly used, in 1/24 hours

% Constraints
constraint A1 * x1 + A2 * x2 <= assembly_regular + ot;
constraint ot <= assembly_overtime_max;

constraint T1 * x1 + T2 * x2 <= testing_max;

% Objective: maximize profit
% profit = revenue - raw - overtime
var int: profitM =
  value1M * x1 + value2M * x2
  - raw1M * x1 - raw2M * x2
  - overtime_cost_per_unitM * ot;

solve maximize profitM;

% Output rounded to nearest dollar.
% profitM is in half-cents. Convert to dollars:
% dollars = profitM / 200 (since 1 dollar = 100 cents = 200 half-cents)
% nearest dollar: (profitM + 100) div 200 for nonnegative profit (true here).
output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "overtime_hours = ", show(ot / 24.0), "\n",
  "profit_nearest_dollar = $", show((profitM + 100) div 200), "\n"
];