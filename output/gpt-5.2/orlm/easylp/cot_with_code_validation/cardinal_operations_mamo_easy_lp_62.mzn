% Parameters
int: bw_cost = 5;
int: lat_cost = 10;
int: min_quality = 200;
int: max_limit = 500;

% Variables
var 0..max_limit: bw;   % integer improvement in bandwidth
var 0..max_limit: lat;  % integer reduction in latency

var 0..(bw_cost*max_limit + lat_cost*max_limit): total_cost;

% Constraints
constraint 2*bw + lat >= min_quality;
constraint 3*bw + lat <= max_limit;

constraint total_cost = bw_cost*bw + lat_cost*lat;

% Objective
solve minimize total_cost;