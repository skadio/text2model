% Parameters (with values embedded)
int: max_total_properties = 100;

% ROI constraint: 0.3*X + 0.4*Y >= 30
int: roi_scale = 10;                  % scale by 10 to avoid decimals
int: roi_rhs = 30 * roi_scale;        % 300
int: roi_coeff_X = 3;                 % 0.3 * 10
int: roi_coeff_Y = 4;                 % 0.4 * 10

% Risk diversification: (1/2)X - (1/5)Y <= 40
int: risk_scale = 10;                 % scale by 10 to clear denominators 2 and 5
int: risk_rhs = 40 * risk_scale;      % 400
int: risk_coeff_X = 5;                % (1/2)*10
int: risk_coeff_Y = 2;                % (1/5)*10

int: min_residential = 10;
int: min_commercial = 5;

int: cost_residential = 50000;
int: cost_commercial = 70000;

% Variables
var min_residential..max_total_properties: X;  % residential properties
var min_commercial..max_total_properties: Y;   % commercial properties

var 0..(max_total_properties * max(cost_residential, cost_commercial)): total_cost;

% Constraints
constraint X + Y <= max_total_properties;

constraint roi_coeff_X * X + roi_coeff_Y * Y >= roi_rhs;

constraint risk_coeff_X * X - risk_coeff_Y * Y <= risk_rhs;

constraint total_cost = cost_residential * X + cost_commercial * Y;

% Objective
solve minimize total_cost;