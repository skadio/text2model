% Parameters (with values embedded)
int: bw_cost = 5;          % resources per unit increase in bandwidth
int: lat_cost = 10;        % resources per unit decrease in latency
int: min_quality = 200;    % 2*bw + lat >= 200
int: max_limit = 500;      % 3*bw + lat <= 500

% Variables
var 0..166: bw;            % bandwidth improvement (bounded from constraints)
var 0..500: lat;           % latency reduction (bounded from constraints)
var 0..5830: total_cost;   % upper bound: 5*166 + 10*500 = 5830

% Constraints
constraint 2*bw + lat >= min_quality;
constraint 3*bw + lat <= max_limit;

constraint total_cost = bw_cost*bw + lat_cost*lat;

% Objective
solve minimize total_cost;