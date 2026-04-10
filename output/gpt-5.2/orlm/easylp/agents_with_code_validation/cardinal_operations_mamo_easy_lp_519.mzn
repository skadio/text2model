% Parameters
int: max_total_capacity = 500;                 % Fleet-wide maximum capacity

int: cost_X = 5;                              % Cost per unit on route X
int: cost_Y = 10;                             % Cost per unit on route Y
int: cost_Z = 15;                             % Cost per unit on route Z

int: min_X = 100;                             % Minimum allocation on route X
int: min_Y = 150;                             % Minimum allocation on route Y
int: min_Z = 200;                             % Minimum allocation on route Z

int: lb_X = 0; int: ub_X = 300;               % Bounds for route X allocation
int: lb_Y = 0; int: ub_Y = 400;               % Bounds for route Y allocation
int: lb_Z = 0; int: ub_Z = 600;               % Bounds for route Z allocation


% Variables
var lb_X..ub_X: alloc_X;                      % Integer allocation to route X
var lb_Y..ub_Y: alloc_Y;                      % Integer allocation to route Y
var lb_Z..ub_Z: alloc_Z;                      % Integer allocation to route Z

var 0..(cost_X*ub_X + cost_Y*ub_Y + cost_Z*ub_Z): total_cost;  % Total cost


% Constraints
% --- Minimum service level constraints per route ---
constraint alloc_X >= min_X;   % Route X minimum allocation
constraint alloc_Y >= min_Y;   % Route Y minimum allocation
constraint alloc_Z >= min_Z;   % Route Z minimum allocation

% --- Fleet-wide total capacity constraint ---
constraint alloc_X + alloc_Y + alloc_Z <= max_total_capacity;

% --- Total cost definition constraint ---
constraint total_cost = cost_X*alloc_X + cost_Y*alloc_Y + cost_Z*alloc_Z;


% Objective
solve minimize total_cost;