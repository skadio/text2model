% Parameters
int: total_bw = 10000;              % Total bandwidth available (units)
int: cost_x = 20;                   % Cost per unit allocated to service X ($/unit)
int: cost_y = 30;                   % Cost per unit allocated to service Y ($/unit)

int: rhs1 = 3000;                   % RHS for constraint x - 0.5y >= 3000
int: rhs2 = 2000;                   % RHS for constraint y - 0.75x <= 2000

% Variables
var 0..total_bw: x;                 % Bandwidth allocated to service X (integer units)
var 0..total_bw: y;                 % Bandwidth allocated to service Y (integer units)

var 0..(cost_x*total_bw + cost_y*total_bw): total_cost;  % Total cost ($, integer)

% Constraints
% --- Total bandwidth capacity ---
constraint x + y <= total_bw;

% --- Service quality constraint: x - 0.5y >= 3000 ---
% Integer form: 2x - y >= 2*rhs1
constraint 2 * x - y >= 2 * rhs1;

% --- Balanced distribution constraint: y - 0.75x <= 2000 ---
% Integer form: 4y - 3x <= 4*rhs2
constraint 4 * y - 3 * x <= 4 * rhs2;

% --- Total cost definition ---
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;