include "globals.mzn";

% Data (embedded)
int: cart_rate = 5;          % kg/min per cart
int: trolley_rate = 7;       % kg/min per trolley
int: cart_workers = 2;       % workers per cart
int: trolley_workers = 4;    % workers per trolley
int: min_trolleys = 12;      % at least 12 trolleys
int: demand_rate = 100;      % required kg/min
int: trolley_max_pct = 40;   % max 40% of transport using trolleys

% Decision variables
var 0..1000: carts;
var 0..1000: trolleys;

% Constraints
constraint trolleys >= min_trolleys;

% Meet required delivery rate
constraint cart_rate * carts + trolley_rate * trolleys >= demand_rate;

% At most 40% of transport (by kg/min capacity) can be via trolleys:
%  trolley_rate*trolleys <= 0.40*(cart_rate*carts + trolley_rate*trolleys)
% Multiply by 100 to avoid fractions:
constraint 100 * trolley_rate * trolleys <= trolley_max_pct * (cart_rate * carts + trolley_rate * trolleys);

% Objective: minimize total workers
var 0..100000: total_workers = cart_workers * carts + trolley_workers * trolleys;

solve minimize total_workers;

output [
  "carts = ", show(carts), "\n",
  "trolleys = ", show(trolleys), "\n",
  "total_workers = ", show(total_workers), "\n",
  "total_rate = ", show(cart_rate*carts + trolley_rate*trolleys), " kg/min\n",
  "trolley_rate_share = ", show(100 * trolley_rate*trolleys div max(1, (cart_rate*carts + trolley_rate*trolleys))), "%\n"
];