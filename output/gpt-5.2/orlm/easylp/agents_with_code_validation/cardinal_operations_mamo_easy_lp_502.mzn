% Parameters
int: max_total_properties = 100;             % Upper limit on total number of properties
float: roi_residential_frac = 0.30;          % Fraction of residential contributing to ROI constraint
float: roi_commercial_frac  = 0.40;          % Fraction of commercial contributing to ROI constraint
float: min_roi_income = 30.0;                % Minimum required combined ROI measure

float: risk_residential_coeff = 0.50;        % Coefficient on residential in risk constraint
float: risk_commercial_coeff  = 0.20;        % Coefficient on commercial in risk constraint (1/5)
float: max_risk_diff = 40.0;                 % Maximum allowed absolute difference

int: min_residential = 10;                   % Minimum number of residential properties
int: min_commercial  = 5;                    % Minimum number of commercial properties

int: cost_residential = 50000;               % Cost per residential unit
int: cost_commercial  = 70000;               % Cost per commercial unit


% Variables
var min_residential..max_total_properties: X; % Residential properties (integer)
var min_commercial..max_total_properties: Y;  % Commercial properties (integer)

var 0..(cost_residential*max_total_properties + cost_commercial*max_total_properties): total_cost;


% Constraints
% --- Total properties capacity constraint ---
constraint
  X + Y <= max_total_properties;

% --- ROI (rental income) requirement ---
constraint
  roi_residential_frac * int2float(X) + roi_commercial_frac * int2float(Y) >= min_roi_income;

% --- Risk diversification constraint (absolute difference bound) ---
constraint
  abs(risk_residential_coeff * int2float(X) - risk_commercial_coeff * int2float(Y)) <= max_risk_diff;

% --- Total cost definition ---
constraint
  total_cost = cost_residential * X + cost_commercial * Y;


% Objective
solve minimize total_cost;