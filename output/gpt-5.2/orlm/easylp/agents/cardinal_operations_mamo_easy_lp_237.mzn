% Parameters
% Cultivation cost per acre for each crop
int: cost_wheat = 5;
int: cost_corn  = 4;
int: cost_soy   = 6;

% Constraint right-hand sides
int: rhs_soil1  = 50;  % 2*wheat + corn <= 50
int: rhs_soil2  = 60;  % wheat + 3*soy <= 60
int: rhs_market = 30;  % corn + soy >= 30


% Variables
% Acres allocated to each crop (whole numbers; non-negative)
var 0..rhs_soil2: wheat_acres;  % safe upper bound from wheat + 3*soy <= 60
var 0..rhs_soil1: corn_acres;   % safe upper bound from 2*wheat + corn <= 50
var 0..rhs_soil2: soy_acres;    % safe upper bound (<= 60 is safe; true tighter bound would be 20)

% Total cost (bounded using max possible acres per crop)
var 0..(cost_wheat*rhs_soil2 + cost_corn*rhs_soil1 + cost_soy*rhs_soil2): total_cost;


% Constraints
%--- Cost definition ----------------------------------------------------------
% Total cultivation cost from allocated acres and per-acre costs
constraint
  total_cost = cost_wheat * wheat_acres
             + cost_corn  * corn_acres
             + cost_soy   * soy_acres;

%--- Soil quality restrictions ------------------------------------------------
constraint 2 * wheat_acres + corn_acres <= rhs_soil1;
constraint wheat_acres + 3 * soy_acres <= rhs_soil2;

%--- Market demand requirement ------------------------------------------------
constraint corn_acres + soy_acres >= rhs_market;


% Objective
solve minimize total_cost;