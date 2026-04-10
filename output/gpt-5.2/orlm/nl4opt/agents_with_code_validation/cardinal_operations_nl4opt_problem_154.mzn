% Parameters
int: regular_capacity = 500;         % packages/day delivered by one regular van
int: hybrid_capacity  = 300;         % packages/day delivered by one hybrid van
int: regular_pollution = 200;        % pollution units/day produced by one regular van
int: hybrid_pollution  = 100;        % pollution units/day produced by one hybrid van
int: max_pollution = 7000;           % maximum allowed pollution units/day
int: min_packages  = 20000;          % minimum required packages/day

% Variables
% Upper bounds are safe over-approximations based on meeting demand with only that type of van.
var 0..(min_packages div regular_capacity + 1): regular_vans;  % number of regular vans to buy
var 0..(min_packages div hybrid_capacity + 1):  hybrid_vans;   % number of hybrid vans to buy

% Constraints
% Pollution limit constraint: total pollutants produced per day must not exceed legal maximum
constraint
  regular_pollution * regular_vans + hybrid_pollution * hybrid_vans <= max_pollution;

% Delivery requirement constraint: total packages delivered per day must meet minimum demand
constraint
  regular_capacity * regular_vans + hybrid_capacity * hybrid_vans >= min_packages;

% Objective
solve minimize regular_vans + hybrid_vans;