% Parameters
int: cart_rate = 5;            % kg/min per cart
int: cart_workers = 2;         % workers per cart
int: trolley_rate = 7;         % kg/min per trolley
int: trolley_workers = 4;      % workers per trolley
int: min_trolleys = 12;        % at least 12 trolleys
int: required_rate = 100;      % kg/min required
int: max_trolley_percent = 40; % max 40% of transport via trolleys

% Variables
var 0..required_rate: carts;
var min_trolleys..required_rate: trolleys;
var 0..(cart_workers*required_rate + trolley_workers*required_rate): total_workers;

% Constraints
constraint
  cart_rate * carts + trolley_rate * trolleys >= required_rate;

constraint
  total_workers = cart_workers * carts + trolley_workers * trolleys;

constraint
  100 * trolley_rate * trolleys <= max_trolley_percent * (cart_rate * carts + trolley_rate * trolleys);

% Objective
solve minimize total_workers;