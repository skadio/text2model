% Parameters
% All data embedded as per instruction (no .dzn expected)
int: limit_xy = 100;          % X + Y <= 100 availability constraint
int: limit_xz = 80;           % X + Z <= 80 logistical constraint
int: min_yz  = 70;            % Y + Z >= 70 efficiency constraint

int: cost_x = 2;              % cost per unit of X
int: cost_y = 3;              % cost per unit of Y
int: cost_z = 1;              % cost per unit of Z

% Variables
var 0..limit_xy: x;           % allocation of resource X (nonnegative integer)
var 0..limit_xy: y;           % allocation of resource Y (nonnegative integer)
var 0..limit_xz: z;           % allocation of resource Z (nonnegative integer)

% Upper bound is a safe (not necessarily tight) cost bound based on max domains
var 0..(cost_x*limit_xy + cost_y*limit_xy + cost_z*limit_xz): total_cost;

% Constraints
% --- Resource availability constraint (X + Y limited) ---
constraint x + y <= limit_xy;

% --- Logistical constraint (X + Z limited) ---
constraint x + z <= limit_xz;

% --- Production efficiency constraint (Y + Z minimum) ---
constraint y + z >= min_yz;

% --- Total cost definition (linking decision vars to cost) ---
constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;