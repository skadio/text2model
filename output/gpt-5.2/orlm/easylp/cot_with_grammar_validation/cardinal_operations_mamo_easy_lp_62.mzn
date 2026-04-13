% Parameters
int: cost_bw = 5;
int: cost_lat = 10;
int: min_quality = 200;          % 2*bw + lat >= 200
int: max_limit = 500;            % 3*bw + lat <= 500

% Variables
var 0..166: bw;                  % improvement in bandwidth (integer), bounded by 3*bw <= 500
var 0..500: lat;                 % reduction in latency (integer), bounded by lat <= 500
var 0..5830: total_cost;         % upper bound: 5*166 + 10*500 = 5830

% Constraints
constraint 2*bw + lat >= min_quality;
constraint 3*bw + lat <= max_limit;

constraint total_cost = cost_bw*bw + cost_lat*lat;

% Objective
solve minimize total_cost;