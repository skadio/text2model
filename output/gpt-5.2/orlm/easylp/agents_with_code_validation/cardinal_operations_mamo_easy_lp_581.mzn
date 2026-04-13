% Parameters
int: max_total_units = 200;                 % Maximum combined investment units

int: cost_residential = 500;               % Cost per unit of residential (x1)
int: cost_commercial  = 300;               % Cost per unit of commercial (x2)
int: cost_industrial  = 400;               % Cost per unit of industrial (x3)

float: roi_coeff_residential = 0.5;        % ROI coefficient for residential
float: roi_coeff_commercial  = -0.3;       % ROI coefficient for commercial
float: roi_coeff_industrial  = 0.4;        % ROI coefficient for industrial
float: min_roi = 50.0;                     % Minimum required ROI (in $ million)

float: risk_coeff_residential = 0.2;       % Risk coefficient for residential
float: risk_coeff_commercial  = 0.6;       % Risk coefficient for commercial
float: risk_coeff_industrial  = -0.8;      % Risk coefficient for industrial
float: max_risk = 30.0;                    % Maximum allowed risk (in $ million)

int: min_residential = 10;                 % Lower bound for x1
int: max_residential = 100;                % Upper bound for x1
int: min_commercial  = 20;                 % Lower bound for x2
int: max_commercial  = 150;                % Upper bound for x2
int: min_industrial  = 15;                 % Lower bound for x3
int: max_industrial  = 120;                % Upper bound for x3


% Variables
var min_residential..max_residential: x1;  % Units invested in residential
var min_commercial..max_commercial:  x2;   % Units invested in commercial
var min_industrial..max_industrial:  x3;   % Units invested in industrial


% Constraints

% --- Total investment capacity constraint ---
constraint
  x1 + x2 + x3 <= max_total_units;

% --- ROI (profitability) constraint ---
% Use float conversion to avoid int/float coercion issues.
constraint
  roi_coeff_residential * int2float(x1)
+ roi_coeff_commercial  * int2float(x2)
+ roi_coeff_industrial  * int2float(x3)
>= min_roi;

% --- Risk management constraint ---
constraint
  risk_coeff_residential * int2float(x1)
+ risk_coeff_commercial  * int2float(x2)
+ risk_coeff_industrial  * int2float(x3)
<= max_risk;


% Objective
solve minimize
  cost_residential * x1
+ cost_commercial  * x2
+ cost_industrial  * x3;