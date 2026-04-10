% Parameters
int: cart_rate = 5;          % kg/min per cart
int: cart_workers = 2;       % workers per cart
int: trolley_rate = 7;       % kg/min per trolley
int: trolley_workers = 4;    % workers per trolley
int: min_trolleys = 12;      % at least this many trolleys
float: max_trolley_share = 0.40; % max fraction of total transport done by trolleys
int: required_rate = 100;    % kg/min total required

% Variables
var 0..1000: carts;
var min_trolleys..1000: trolleys;
var 0..10000: total_workers;

% Constraints
constraint cart_rate * carts + trolley_rate * trolleys >= required_rate;

% Trolley share: trolley_rate*trolleys <= max_share * (cart_rate*carts + trolley_rate*trolleys)
% Multiply by 100 to avoid floating-point in the constraint:
% 100*trolley_rate*trolleys <= 40*(cart_rate*carts + trolley_rate*trolleys)
constraint 100 * trolley_rate * trolleys <=
          (round(max_trolley_share * 100.0)) * (cart_rate * carts + trolley_rate * trolleys);

constraint total_workers = cart_workers * carts + trolley_workers * trolleys;

% Objective
solve minimize total_workers;