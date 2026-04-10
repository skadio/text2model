% Parameters
int: labor_available = 1000;                 % Total manufacturing labor hours available
int: inspection_available = 500;             % Total inspection hours available

int: labor_high = 17;                        % Labor hours per high-end unit
int: inspection_high = 8;                    % Inspection hours per high-end unit
int: profit_high = 300;                      % Profit per high-end unit (yuan)
int: demand_high_max = 50;                   % Max demand for high-end units

int: labor_mid = 10;                         % Labor hours per mid-range unit
int: inspection_mid = 4;                     % Inspection hours per mid-range unit
int: profit_mid = 200;                       % Profit per mid-range unit (yuan)
int: demand_mid_max = 80;                    % Max demand for mid-range units

int: labor_low = 2;                          % Labor hours per low-end unit
int: inspection_low = 2;                     % Inspection hours per low-end unit
int: profit_low = 100;                       % Profit per low-end unit (yuan)
int: demand_low_max = 150;                   % Max demand for low-end units


% Variables
var 0..demand_high_max: x_high;              % Units produced of high-end type
var 0..demand_mid_max:  x_mid;               % Units produced of mid-range type
var 0..demand_low_max:  x_low;               % Units produced of low-end type

var 0..(profit_high*demand_high_max
      + profit_mid*demand_mid_max
      + profit_low*demand_low_max): total_profit;  % Total profit (yuan)


% Constraints
% Resource capacity constraints (labor and inspection)
constraint
  labor_high * x_high + labor_mid * x_mid + labor_low * x_low <= labor_available;

constraint
  inspection_high * x_high + inspection_mid * x_mid + inspection_low * x_low
  <= inspection_available;

% Total profit definition constraint
constraint
  total_profit = profit_high * x_high + profit_mid * x_mid + profit_low * x_low;


% Objective
solve maximize total_profit;