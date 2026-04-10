% Parameters
%----------------------------
% Budget limit for total investment
%----------------------------
int: budget = 100;

% Demand constraint coefficients and minimum required value
int: a1 = 2;           % coefficient for x1 in demand constraint
int: a2 = 3;           % coefficient for x2 in demand constraint
int: demand_min = 50;  % minimum required demand value

% Risk constraint coefficients and maximum allowed value
int: r1 = 4;          % coefficient for x1 in risk constraint
int: r3 = -5;         % coefficient for x3 in risk constraint (i.e., -5*x3)
int: risk_max = 30;   % maximum allowed risk expression value

% Unit costs (objective coefficients)
int: c1 = 5; % cost per unit of x1
int: c2 = 4; % cost per unit of x2
int: c3 = 3; % cost per unit of x3

% Supplier maximum allocation limits (use budget as a safe upper bound)
int: x1_max = budget;
int: x2_max = budget;
int: x3_max = budget;

% Variables
%----------------------------
% Integer investments for each supplier
%----------------------------
var 0..x1_max: x1;
var 0..x2_max: x2;
var 0..x3_max: x3;

% Total cost (upper bound based on maxima)
var 0..(c1*x1_max + c2*x2_max + c3*x3_max): total_cost;

% Constraints
%----------------------------
% Total investment / budget
%----------------------------
constraint x1 + x2 + x3 <= budget;

%----------------------------
% Demand satisfaction
%----------------------------
constraint a1 * x1 + a2 * x2 >= demand_min;

%----------------------------
% Risk management constraint
%----------------------------
constraint r1 * x1 + r3 * x3 <= risk_max;

%----------------------------
% Total cost definition
%----------------------------
constraint total_cost = c1 * x1 + c2 * x2 + c3 * x3;

% Objective
solve minimize total_cost;