% Parameters
int: regular_capacity  = 500;   % packages/day delivered by one regular van
int: hybrid_capacity   = 300;   % packages/day delivered by one hybrid van
int: regular_pollution = 200;   % pollution units/day produced by one regular van
int: hybrid_pollution  = 100;   % pollution units/day produced by one hybrid van
int: max_pollution     = 7000;  % maximum allowed pollution units/day
int: min_packages      = 20000; % minimum required packages/day

% Safe upper bound: if all vans were the least-capacity type (hybrid = 300).
% Use ceil(min_packages / 300) = (min_packages + 300 - 1) div 300
int: max_vans = (min_packages + min(regular_capacity, hybrid_capacity) - 1)
               div min(regular_capacity, hybrid_capacity);

% Variables
var 0..max_vans: n_regular;     % number of regular vans to buy
var 0..max_vans: n_hybrid;      % number of hybrid vans to buy

% Constraints
% --- Delivery capacity constraint ---
% Ensure the fleet can deliver at least the required number of packages per day.
constraint
  regular_capacity * n_regular + hybrid_capacity * n_hybrid >= min_packages;

% --- Environmental (pollution) constraint ---
% Ensure total daily pollution does not exceed the legal limit.
constraint
  regular_pollution * n_regular + hybrid_pollution * n_hybrid <= max_pollution;

% Objective
solve minimize n_regular + n_hybrid;