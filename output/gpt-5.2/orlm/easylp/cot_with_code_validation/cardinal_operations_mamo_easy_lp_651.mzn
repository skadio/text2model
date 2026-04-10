% Parameters
int: cost1 = 500;
int: cost2 = 300;
int: cost3 = 200;
int: cost4 = 100;

int: max12 = 50;
int: max34 = 70;

int: roi_min_scaled = 20 * 20; % scale by 20 to clear denominators
int: risk_max_scaled = 30 * 4; % scale by 4 to clear denominators

% Variables
var 0..max12: x1;
var 0..max12: x2;
var 0..max34: x3;
var 0..max34: x4;

var 0..(cost1*max12 + cost2*max12 + cost3*max34 + cost4*max34): total_cost;

% Constraints
constraint x1 + x2 <= max12;
constraint x3 + x4 <= max34;

% ROI: 0.5*x1 - 0.25*x2 + 0.15*x3 + 1*x4 >= 20
% scaled by 20: 10*x1 - 5*x2 + 3*x3 + 20*x4 >= 400
constraint 10*x1 - 5*x2 + 3*x3 + 20*x4 >= roi_min_scaled;

% Risk: (2.5*x2 + 0.75*x3 - x1 - x4) <= 30
% scaled by 4: 10*x2 + 3*x3 - 4*x1 - 4*x4 <= 120
constraint 10*x2 + 3*x3 - 4*x1 - 4*x4 <= risk_max_scaled;

constraint total_cost = cost1*x1 + cost2*x2 + cost3*x3 + cost4*x4;

% Objective
solve minimize total_cost;