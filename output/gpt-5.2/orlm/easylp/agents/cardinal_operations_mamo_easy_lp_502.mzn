% Parameters
int: max_properties = 100;              % Maximum total number of properties (X + Y)

float: roi_min = 30.0;                  % Minimum required combined average monthly rental income
float: roi_res_frac = 0.30;             % Fraction of residential properties contributing to ROI
float: roi_com_frac = 0.40;             % Fraction of commercial properties contributing to ROI

float: risk_res_coeff = 0.5;            % Coefficient for residential in diversification constraint
float: risk_com_coeff = 0.2;            % Coefficient for commercial in diversification constraint (1/5)
float: risk_max = 40.0;                 % Maximum allowed difference in diversification constraint

int: min_res = 10;                      % Minimum number of residential properties
int: min_com = 5;                       % Minimum number of commercial properties

int: cost_res = 50000;                  % Cost per residential property
int: cost_com = 70000;                  % Cost per commercial property

% Variables
var min_res..max_properties: X;         % Number of residential properties (integer)
var min_com..max_properties: Y;         % Number of commercial properties (integer)

var 0..(cost_res*max_properties + cost_com*max_properties): total_cost; % Total investment cost (integer)

% Constraints

% Total properties limit
constraint
  X + Y <= max_properties;

% ROI requirement: 0.30*X + 0.40*Y >= 30
constraint
  roi_res_frac * int2float(X) + roi_com_frac * int2float(Y) >= roi_min;

% Risk diversification: |0.5*X - 0.2*Y| <= 40
constraint
  abs(risk_res_coeff * int2float(X) - risk_com_coeff * int2float(Y)) <= risk_max;

% Total cost definition
constraint
  total_cost = cost_res * X + cost_com * Y;

% Objective
solve minimize total_cost;