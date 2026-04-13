% Fertilizer production planning (LP)
% Maximize total ending inventory (liquid + solid)

% -----------------------
% Data (embedded)
% -----------------------
float: m1_hours = 40.0;
float: m2_hours = 35.0;

float: m1_minutes = 60.0 * m1_hours;   % 2400
float: m2_minutes = 60.0 * m2_hours;   % 2100

float: onhand_liq = 30.0;
float: onhand_sol = 90.0;

float: demand_liq = 75.0;
float: demand_sol = 95.0;

% Processing minutes per lot
float: m1_liq = 50.0;
float: m2_liq = 30.0;
float: m1_sol = 24.0;
float: m2_sol = 33.0;

% -----------------------
% Decision variables
% -----------------------
var float: x_liq;   % lots of liquid produced (can be fractional)
var float: x_sol;   % lots of solid produced (can be fractional)

var float: end_liq; % ending inventory liquid
var float: end_sol; % ending inventory solid

% -----------------------
% Constraints
% -----------------------
% Nonnegativity
constraint x_liq >= 0.0;
constraint x_sol >= 0.0;
constraint end_liq >= 0.0;
constraint end_sol >= 0.0;

% Machine capacities (minutes)
constraint m1_liq * x_liq + m1_sol * x_sol <= m1_minutes;
constraint m2_liq * x_liq + m2_sol * x_sol <= m2_minutes;

% Inventory balance (all demand must be met)
constraint end_liq = onhand_liq + x_liq - demand_liq;
constraint end_sol = onhand_sol + x_sol - demand_sol;

% -----------------------
% Objective
% -----------------------
solve maximize end_liq + end_sol;

% -----------------------
% Output
% -----------------------
output [
  "x_liq (produced lots) = ", show(x_liq), "\n",
  "x_sol (produced lots) = ", show(x_sol), "\n",
  "end_liq (ending inv)  = ", show(end_liq), "\n",
  "end_sol (ending inv)  = ", show(end_sol), "\n",
  "total ending inv      = ", show(end_liq + end_sol), "\n"
];