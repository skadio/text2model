% Parameters
% Investment bounds for each project (whole units)
int: x_lb = 0;
int: x_ub = 2000;
int: y_lb = 0;
int: y_ub = 1500;
int: z_lb = 0;
int: z_ub = 2500;

% Joint investment constraints
int: xy_ub = 5000;   % X + Y <= 5000
int: yz_lb = 3000;   % Y + Z >= 3000
int: xz_ub = 4000;   % X + Z <= 4000

% Unit costs/returns per unit investment (objective coefficients)
int: cost_x = 10;
int: cost_y = 15;
int: cost_z = 20;

% Variables
var x_lb..x_ub: invest_x;  % Investment in project X (integer units)
var y_lb..y_ub: invest_y;  % Investment in project Y (integer units)
var z_lb..z_ub: invest_z;  % Investment in project Z (integer units)

% Total cost to minimize (bounded by the maximum possible cost under variable bounds)
var 0..(cost_x*x_ub + cost_y*y_ub + cost_z*z_ub): total_cost;

% Constraints
% --- Joint investment (pairwise) constraints ---
constraint invest_x + invest_y <= xy_ub;
constraint invest_y + invest_z >= yz_lb;
constraint invest_x + invest_z <= xz_ub;

% --- Total cost definition constraint ---
constraint total_cost = cost_x * invest_x + cost_y * invest_y + cost_z * invest_z;

% Objective
solve minimize total_cost;