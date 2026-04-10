% Parameters
int: max_total_props = 100;
int: min_residential = 10;
int: min_commercial  = 5;

float: roi_res_frac = 0.3;
float: roi_com_frac = 0.4;
float: roi_min = 30.0;

float: risk_res_coef = 0.5;
float: risk_com_coef = 0.2;
float: risk_max_diff = 40.0;

int: cost_residential = 50000;
int: cost_commercial  = 70000;

% Variables
var min_residential..max_total_props: X; % residential properties
var min_commercial..max_total_props: Y;  % commercial properties

var 0..(cost_residential*max_total_props + cost_commercial*max_total_props): total_cost;

% Constraints
constraint X + Y <= max_total_props;

% ROI constraint: 0.3*X + 0.4*Y >= 30
constraint roi_res_frac * int2float(X) + roi_com_frac * int2float(Y) >= roi_min;

% Risk diversification: |0.5*X - 0.2*Y| <= 40
constraint abs(risk_res_coef * int2float(X) - risk_com_coef * int2float(Y)) <= risk_max_diff;

% Total cost definition
constraint total_cost = cost_residential * X + cost_commercial * Y;

% Objective
solve minimize total_cost;