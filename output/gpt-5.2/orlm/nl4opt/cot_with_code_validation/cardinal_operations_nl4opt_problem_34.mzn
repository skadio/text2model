% Parameters
int: cart_rate = 5;          % kg/min per cart
int: cart_workers = 2;       % workers per cart
int: trolley_rate = 7;       % kg/min per trolley
int: trolley_workers = 4;    % workers per trolley
int: min_trolleys = 12;      % at least this many trolleys
int: required_rate = 100;    % kg/min total required
int: trolley_pct_max_num = 2; % 40% = 2/5
int: trolley_pct_max_den = 5;

% Variables
var 0..required_rate: carts;
var min_trolleys..required_rate: trolleys;
var 0..(cart_workers*required_rate + trolley_workers*required_rate): total_workers;

% Constraints
constraint
  cart_rate * carts + trolley_rate * trolleys >= required_rate;

% at most 40% of total transported kg/min can be via trolleys:
% trolley_rate*trolleys <= 0.4*(cart_rate*carts + trolley_rate*trolleys)
% multiply by 5: 5*trolley_rate*trolleys <= 2*(cart_rate*carts + trolley_rate*trolleys)
constraint
  trolley_pct_max_den * trolley_rate * trolleys
  <= trolley_pct_max_num * (cart_rate * carts + trolley_rate * trolleys);

constraint
  total_workers = cart_workers * carts + trolley_workers * trolleys;

% Objective
solve minimize total_workers;