% Parameters
int: cost_house = 400000;
int: cost_apt   = 600000;

int: demand_min = 500;     % 1.5*x + 2*y >= 500
int: workload_max = 300;   % 0.75*x + 1*y <= 300

% Scale to avoid fractions:
% 1.5*x + 2*y >= 500  -> 3*x + 4*y >= 1000
% 0.75*x + y <= 300   -> 3*x + 4*y <= 1200
int: scale_demand = 1000;
int: scale_workload = 1200;

% Upper bounds derived from constraints:
% From 3x + 4y <= 1200 => x <= 400, y <= 300
int: x_ub = 400;
int: y_ub = 300;

% Variables
var 0..x_ub: x; % number of houses
var 0..y_ub: y; % number of apartments

% Constraints
constraint 3*x + 4*y >= scale_demand;
constraint 3*x + 4*y <= scale_workload;

% Objective
solve minimize cost_house * x + cost_apt * y;