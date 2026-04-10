% Parameters
int: total_cap = 1000;
int: min_x_more_than_2y = 100;      % X >= 2*Y + 100
int: max_diff_yz = 50;              % |Y - Z| <= 50
int: min_x_plus_z = 300;            % X + Z >= 300

int: cost_x = 2;
int: cost_y = 3;
int: cost_z = 4;

% Operational bounds (not specified beyond nonnegativity and total capacity)
int: x_lb = 0;
int: y_lb = 0;
int: z_lb = 0;
int: x_ub = total_cap;
int: y_ub = total_cap;
int: z_ub = total_cap;

% Variables
var x_lb..x_ub: X;
var y_lb..y_ub: Y;
var z_lb..z_ub: Z;

var 0..(cost_x*total_cap + cost_y*total_cap + cost_z*total_cap): TotalCost;

% Constraints
constraint X + Y + Z <= total_cap;

constraint X >= 2*Y + min_x_more_than_2y;

constraint abs(Y - Z) <= max_diff_yz;

constraint X + Z >= min_x_plus_z;

constraint TotalCost = cost_x*X + cost_y*Y + cost_z*Z;

% Objective
solve minimize TotalCost;