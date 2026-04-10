% Concert equipment transport optimization
% Decision variables:
%   c = number of carts
%   t = number of trolleys

int: cart_rate = 5;        % kg/min per cart
int: trolley_rate = 7;     % kg/min per trolley
int: cart_workers = 2;     % workers per cart
int: trolley_workers = 4;  % workers per trolley

int: required_rate = 100;  % kg/min total required
int: min_trolleys = 12;    % at least 12 trolleys
int: max_trolley_pct = 40; % at most 40% of transportation via trolleys

% Upper bounds (safe, not too large)
int: max_carts = required_rate div cart_rate + 100;      % plenty
int: max_trolleys_ub = required_rate div trolley_rate + 100;

var 0..max_carts: c;
var 0..max_trolleys_ub: t;

% Total delivered rate
var int: total_rate = cart_rate * c + trolley_rate * t;

% Objective: minimize total workers
var int: total_workers = cart_workers * c + trolley_workers * t;

constraint t >= min_trolleys;
constraint total_rate >= required_rate;

% At most 40% of the transportation (by kg/min) can be using trolleys:
% 7t <= 0.4 * (5c + 7t)  <=>  3*(7t) <= 2*(5c + 7t)  (multiply by 5)
constraint 3 * (trolley_rate * t) <= 2 * total_rate;

solve minimize total_workers;

output [
  "carts = ", show(c), "\n",
  "trolleys = ", show(t), "\n",
  "total_rate(kg/min) = ", show(total_rate), "\n",
  "total_workers = ", show(total_workers), "\n"
];