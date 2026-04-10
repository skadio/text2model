% Parameters
% Production capacity (total units across all products)
int: max_total_production = 500;

% Demand-type constraints
int: min_2x_plus_y = 200;          % minimum for 2*X + Y
int: min_y_plus_z = 150;           % minimum for Y + Z

% Unit production costs
int: cost_x = 50;
int: cost_y = 60;
int: cost_z = 20;

% Individual production bounds
int: x_min = 0;
int: x_max = 300;

int: y_min = 0;
int: y_max = 200;

int: z_min = 0;
int: z_max = 100;


% Variables
% Integer production quantities (whole units)
var x_min..x_max: x;   % units of product X
var y_min..y_max: y;   % units of product Y
var z_min..z_max: z;   % units of product Z

% Total cost (bounded using max unit costs and max productions)
var 0..(cost_x*x_max + cost_y*y_max + cost_z*z_max): total_cost;  % total production cost


% Constraints
%------------------------------
% Total production capacity
%------------------------------
constraint
  x + y + z <= max_total_production;

%------------------------------
% Demand / requirement constraints
%------------------------------
constraint
  2 * x + y >= min_2x_plus_y;

constraint
  y + z >= min_y_plus_z;

%------------------------------
% Total cost definition
%------------------------------
constraint
  total_cost = cost_x * x + cost_y * y + cost_z * z;


% Objective
solve minimize total_cost;