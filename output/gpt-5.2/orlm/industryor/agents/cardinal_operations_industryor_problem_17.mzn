% Parameters
int: shifts = 2;                         % number of shifts (given, but not directly used)
int: weekly_regular_hours = 110;         % regular weekly production time (hours)
int: max_overtime_hours = 10;            % maximum allowed overtime (hours)

int: prod_rate_m_per_hour = 1000;        % production rate (meters per hour) for both fabrics

int: min_curtain_sold_m = 70000;         % minimum weekly sales for curtain fabric (meters)
int: min_clothing_sold_m = 45000;        % minimum weekly sales for clothing fabric (meters)

float: profit_curtain_per_m = 2.5;       % profit for curtain fabric (yuan per meter)
float: profit_clothing_per_m = 1.5;      % profit for clothing fabric (yuan per meter)

% Helpful derived bounds (integer hours needed to meet minimum sales)
int: min_curtain_hours = ceil(min_curtain_sold_m / prod_rate_m_per_hour);
int: min_clothing_hours = ceil(min_clothing_sold_m / prod_rate_m_per_hour);

int: max_total_hours = weekly_regular_hours + max_overtime_hours; % max possible hours incl. overtime


% Variables
var 0..max_total_hours: hours_curtain;    % production hours assigned to curtain fabric
var 0..max_total_hours: hours_clothing;   % production hours assigned to clothing fabric

var 0..max_total_hours: total_prod_hours; % total weekly production hours used
var 0..max_overtime_hours: overtime_hours;% overtime hours used (to be minimized)

var 0..(prod_rate_m_per_hour * max_total_hours): meters_curtain;   % meters of curtain fabric produced/sold
var 0..(prod_rate_m_per_hour * max_total_hours): meters_clothing;  % meters of clothing fabric produced/sold

var float: total_profit;                 % total weekly profit (yuan)


% Constraints

% --- Production time accounting (p1) ---
constraint
  % Total production hours equals the sum of hours allocated to both fabrics
  total_prod_hours = hours_curtain + hours_clothing;

constraint
  % Fully utilize the 110 regular hours (production uses at least regular hours; extra becomes overtime)
  total_prod_hours = weekly_regular_hours + overtime_hours;

% --- Overtime limit (p2) ---
constraint
  % Overtime must not exceed the weekly maximum
  overtime_hours <= max_overtime_hours;

% --- Production meters definition ---
constraint
  % Produced/sold meters are determined by production hours and the common production rate
  meters_curtain = prod_rate_m_per_hour * hours_curtain;

constraint
  meters_clothing = prod_rate_m_per_hour * hours_clothing;

% --- Minimum sales requirements (p3) ---
constraint
  % At least the minimum demand/sales for each fabric must be met
  meters_curtain >= min_curtain_sold_m;

constraint
  meters_clothing >= min_clothing_sold_m;

% Optional strengthening using derived hour lower bounds (tightens search; consistent with p3)
constraint hours_curtain >= min_curtain_hours;
constraint hours_clothing >= min_clothing_hours;

% --- Profit calculation (derived expression; supports reporting/secondary evaluation) ---
constraint
  total_profit =
    profit_curtain_per_m * float(meters_curtain) +
    profit_clothing_per_m * float(meters_clothing);


% Objective
solve minimize overtime_hours;