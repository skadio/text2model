% Parameters
% Investment cost per unit (USD)
int: cost_residential = 500;
int: cost_commercial  = 300;
int: cost_industrial  = 400;

% Total investment upper bound (units)
int: max_total_units = 200;

% ROI constraint coefficients and RHS (in million $ units as given)
float: roi_coef_residential = 0.5;
float: roi_coef_commercial  = -0.3;
float: roi_coef_industrial  = 0.4;
float: min_roi = 50.0;

% Risk constraint coefficients and RHS (in million $ units as given)
float: risk_coef_residential = 0.2;
float: risk_coef_commercial  = 0.6;
float: risk_coef_industrial  = -0.8;
float: max_risk = 30.0;

% Bounds on each investment type (units)
int: res_lb = 10;  int: res_ub = 100;
int: com_lb = 20;  int: com_ub = 150;
int: ind_lb = 15;  int: ind_ub = 120;


% Variables
% Decision variables: number of units invested in each property type (whole numbers)
var res_lb..res_ub: x1;   % residential units
var com_lb..com_ub: x2;   % commercial units
var ind_lb..ind_ub: x3;   % industrial units

% Total cost (USD), bounded using known variable bounds
var 0..(cost_residential*res_ub + cost_commercial*com_ub + cost_industrial*ind_ub): total_cost;

% Helper expressions (float) for linear constraints with float coefficients
% Conservative explicit bounds to keep model well-typed and bounded
var -200.0..200.0: roi_lhs;   % 0.5*x1 - 0.3*x2 + 0.4*x3
var -200.0..200.0: risk_lhs;  % 0.2*x1 + 0.6*x2 - 0.8*x3


% Constraints
% --- Total investment capacity constraint ---
constraint
  x1 + x2 + x3 <= max_total_units;

% --- Define total cost from decision variables ---
constraint
  total_cost = cost_residential * x1
             + cost_commercial  * x2
             + cost_industrial  * x3;

% --- ROI constraint: define LHS helper and enforce minimum ROI ---
constraint
  roi_lhs = roi_coef_residential * int2float(x1)
          + roi_coef_commercial  * int2float(x2)
          + roi_coef_industrial  * int2float(x3);

constraint
  roi_lhs >= min_roi;

% --- Risk constraint: define LHS helper and enforce maximum risk ---
constraint
  risk_lhs = risk_coef_residential * int2float(x1)
           + risk_coef_commercial  * int2float(x2)
           + risk_coef_industrial  * int2float(x3);

constraint
  risk_lhs <= max_risk;


% Objective
solve minimize total_cost;