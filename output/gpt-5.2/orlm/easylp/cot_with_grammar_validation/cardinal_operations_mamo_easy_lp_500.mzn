% Parameters
int: max_total_props = 1000;
int: min_weighted_props = 2000;
int: max_diff = 300;

int: cost_res_k = 200; % thousand dollars per residential property
int: cost_com_k = 150; % thousand dollars per commercial property

% Variables
var 0..max_total_props: X; % residential properties
var 0..max_total_props: Y; % commercial properties
var 0..(cost_res_k*max_total_props + cost_com_k*max_total_props): total_cost_k;

% Constraints
constraint X + Y <= max_total_props;
constraint 3*X + 2*Y >= min_weighted_props;
constraint abs(X - Y) <= max_diff;

constraint total_cost_k = cost_res_k*X + cost_com_k*Y;

% Objective
solve minimize total_cost_k;