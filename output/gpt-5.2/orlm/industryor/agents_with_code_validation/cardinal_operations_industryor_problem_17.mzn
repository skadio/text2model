% Parameters
int: weekly_regular_hours = 110;                  % Target regular production time (hours/week)
int: max_overtime_hours = 10;                     % Maximum allowed overtime (hours/week)
int: production_rate_m_per_hour = 1000;           % Production rate (meters per hour) for both fabrics

int: min_curtain_demand_m = 70000;                % Minimum weekly sales/demand for curtain fabric (meters)
int: min_clothing_demand_m = 45000;               % Minimum weekly sales/demand for clothing fabric (meters)

float: profit_curtain_per_m = 2.5;                % Profit for curtain fabric (yuan/meter)
float: profit_clothing_per_m = 1.5;               % Profit for clothing fabric (yuan/meter)

% Derived bounds for variable domains
int: max_total_hours = weekly_regular_hours + max_overtime_hours;  % Upper bound on total hours
int: max_total_meters = max_total_hours * production_rate_m_per_hour;

% Variables
var 0..max_total_hours: hours_curtain;            % Hours allocated to curtain fabric production
var 0..max_total_hours: hours_clothing;           % Hours allocated to clothing fabric production
var 0..max_total_hours: total_hours;              % Total production hours (regular + overtime)
var 0..max_overtime_hours: overtime_hours;        % Overtime hours used

var 0..max_total_meters: meters_curtain;          % Meters of curtain fabric produced (and sold)
var 0..max_total_meters: meters_clothing;         % Meters of clothing fabric produced (and sold)

var float: total_profit;                          % Total weekly profit (yuan)

% Constraints

% --- Time accounting: total hours split across products ---
constraint
  total_hours = hours_curtain + hours_clothing;

% --- Regular vs overtime decomposition (p1, p2) ---
% Fully utilize the 110 regular hours; any additional hours are overtime.
constraint
  total_hours = weekly_regular_hours + overtime_hours;

% Overtime is already bounded by its domain 0..max_overtime_hours, but restate for clarity.
constraint
  overtime_hours <= max_overtime_hours;

% --- Production rate linking hours to meters (type-consistent integer arithmetic) ---
constraint
  meters_curtain = hours_curtain * production_rate_m_per_hour;

constraint
  meters_clothing = hours_clothing * production_rate_m_per_hour;

% --- Minimum sales/demand requirements (p3) ---
constraint
  meters_curtain >= min_curtain_demand_m;

constraint
  meters_clothing >= min_clothing_demand_m;

% --- Profit calculation (uses float coefficients) ---
constraint
  total_profit =
    profit_curtain_per_m * int2float(meters_curtain)
  + profit_clothing_per_m * int2float(meters_clothing);

% Objective
solve minimize overtime_hours;