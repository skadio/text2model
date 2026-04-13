% Parameters (with values embedded)
int: vintage_capacity = 500;      % ml per vintage bottle
int: regular_capacity = 750;      % ml per regular bottle
int: total_wine = 100000;         % total ml available
int: min_vintage = 10;            % at least 10 vintage bottles
int: regular_to_vintage_ratio = 4; % regular >= 4 * vintage

% Variables
var min_vintage..(total_wine div vintage_capacity): vintage;
var 0..(total_wine div regular_capacity): regular;

% Constraints
constraint vintage_capacity * vintage + regular_capacity * regular <= total_wine;
constraint regular >= regular_to_vintage_ratio * vintage;

% Objective
solve maximize vintage + regular;