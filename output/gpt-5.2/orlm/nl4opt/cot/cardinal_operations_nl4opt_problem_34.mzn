% Parameters (with values embedded)
int: cart_rate = 5;          % kg/min per cart
int: trolley_rate = 7;       % kg/min per trolley
int: cart_workers = 2;       % workers per cart
int: trolley_workers = 4;    % workers per trolley
int: min_trolleys = 12;      % at least this many trolleys
int: demand_rate = 100;      % required kg/min
int: max_cart_bound = 200;   % safe upper bound for carts
int: max_trolley_bound = 200;% safe upper bound for trolleys

% Variables
var 0..max_cart_bound: carts;
var min_trolleys..max_trolley_bound: trolleys;

% Constraints
constraint cart_rate * carts + trolley_rate * trolleys >= demand_rate;

% At most 40% of the transportation (capacity) can be using trolleys:
% 7*trolleys <= 0.4*(5*carts + 7*trolleys)  ->  21*trolleys <= 10*carts
constraint 21 * trolleys <= 10 * carts;

% Objective
var 0..(cart_workers*max_cart_bound + trolley_workers*max_trolley_bound): total_workers;
constraint total_workers = cart_workers * carts + trolley_workers * trolleys;

solve minimize total_workers;