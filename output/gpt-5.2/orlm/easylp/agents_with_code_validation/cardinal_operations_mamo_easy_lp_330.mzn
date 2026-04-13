% Parameters
% Maximum combined budgets
int: max_xy = 100;      % X + Y <= 100
int: max_zw = 200;      % Z + W <= 200

% Minimum combined outreach/budget requirements
int: min_xz = 50;       % X + Z >= 50
int: min_yw = 70;       % Y + W >= 70

% Cost per unit for each channel
int: cost_x = 10;
int: cost_y = 15;
int: cost_z = 25;
int: cost_w = 30;


% Variables
var 0..max_xy: x;       % Budget allocated to channel X (integer, non-negative)
var 0..max_xy: y;       % Budget allocated to channel Y (integer, non-negative)
var 0..max_zw: z;       % Budget allocated to channel Z (integer, non-negative)
var 0..max_zw: w;       % Budget allocated to channel W (integer, non-negative)

% Upper bound: worst-case spending at variable max bounds
var 0..(cost_x*max_xy + cost_y*max_xy + cost_z*max_zw + cost_w*max_zw): total_cost;


% Constraints
%--- Budget cap constraints (maximum combined allocations) ---
constraint x + y <= max_xy;   % X + Y <= 100
constraint z + w <= max_zw;   % Z + W <= 200

%--- Outreach / minimum combined allocation constraints ---
constraint x + z >= min_xz;   % X + Z >= 50
constraint y + w >= min_yw;   % Y + W >= 70

%--- Total cost definition constraint ---
constraint total_cost = cost_x * x + cost_y * y + cost_z * z + cost_w * w;


% Objective
solve minimize total_cost;