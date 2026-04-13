% Parameters
% Cost score per unit invested in each option
int: cost_X = 7;
int: cost_Y = 9;

% Risk tolerance constraint coefficients and RHS
int: risk_coef_X = 4;
int: risk_coef_Y = 5;
int: risk_max = 1000;

% Balance constraint coefficients and RHS (3*X - 2*Y >= 200)
int: balance_coef_X = 3;
int: balance_coef_Y = 2;
int: balance_min = 200;

% Total investment limit (X + Y <= 300)
int: invest_max = 300;


% Variables
% Integer investment amounts in options X and Y (indivisible units)
var 0..invest_max: invest_X;
var 0..invest_max: invest_Y;

% Total cost score to minimize (tight upper bound given invest_max)
var 0..(cost_X * invest_max + cost_Y * invest_max): total_cost;


% Constraints
% Link total_cost to the chosen investment amounts
constraint total_cost = cost_X * invest_X + cost_Y * invest_Y;

% Risk tolerance constraint: 4*X + 5*Y <= 1000
constraint risk_coef_X * invest_X + risk_coef_Y * invest_Y <= risk_max;

% Portfolio balance constraint: 3*X - 2*Y >= 200
constraint balance_coef_X * invest_X - balance_coef_Y * invest_Y >= balance_min;

% Total investment limit: X + Y <= 300
constraint invest_X + invest_Y <= invest_max;


% Objective
solve minimize total_cost;