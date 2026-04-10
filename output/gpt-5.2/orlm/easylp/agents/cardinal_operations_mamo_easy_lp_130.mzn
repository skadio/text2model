% Parameters
float: cost_per_activity_X = 0.5;        % cost per activity for Project X
float: cost_per_activity_Y = 0.3;        % cost per activity for Project Y

int: coef_X = 2;                         % coefficient for X in combined-activities constraint
int: coef_Y = 3;                         % coefficient for Y in combined-activities constraint
int: max_weighted_activities = 5000;     % upper bound on 2*X + 3*Y

int: min_activity_difference = 100;      % minimum required (X - Y)

% Variable bounds derived from: 2*X + 3*Y <= 5000, X,Y >= 0
int: max_X = max_weighted_activities div coef_X;  % floor(5000/2)=2500
int: max_Y = max_weighted_activities div coef_Y;  % floor(5000/3)=1666

% Variables
var 0..max_X: x;                         % integer number of activities for Project X
var 0..max_Y: y;                         % integer number of activities for Project Y

var float: total_cost;                   % total cost = 0.5*x + 0.3*y
var int: rounded_total_cost;             % total_cost rounded to nearest integer

% Constraints

%-------------------------------
% Link total cost to activities
%-------------------------------
constraint
  total_cost = cost_per_activity_X * int2float(x)
             + cost_per_activity_Y * int2float(y);

%---------------------------------------------
% Resource / capacity constraint on activities
%---------------------------------------------
constraint
  coef_X * x + coef_Y * y <= max_weighted_activities;

%----------------------------------------------------
% Minimum difference constraint to maintain balance
% (as given: X - Y must be at least min_activity_difference)
%----------------------------------------------------
constraint
  x - y >= min_activity_difference;

%--------------------------------------------
% Rounded total cost to nearest integer
% (round half up: rounded_total_cost = floor(total_cost + 0.5))
%--------------------------------------------
constraint
  rounded_total_cost = floor(total_cost + 0.5);

% Objective
solve minimize total_cost;