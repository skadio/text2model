% Parameters
int: cart_capacity = 5;                 % kg/min per cart
int: cart_workers = 2;                  % workers required per cart
int: trolley_capacity = 7;              % kg/min per trolley
int: trolley_workers = 4;               % workers required per trolley
int: min_trolleys = 12;                 % minimum number of trolleys to use
float: max_trolley_fraction = 0.40;     % maximum fraction of transport done by trolleys
int: required_rate = 100;               % required delivery rate (kg/min)

% Upper bounds for decision variables (safe, derived from requirement and minima)
int: max_carts = required_rate div cart_capacity + 200;        % conservative upper bound
int: max_trolleys = required_rate div trolley_capacity + 200;  % conservative upper bound

% Variables
var 0..max_carts: carts;                 % number of carts used
var 0..max_trolleys: trolleys;           % number of trolleys used
var 0..(cart_workers*max_carts + trolley_workers*max_trolleys): total_workers; % total workers used

% Constraints

% Total workers definition
constraint
  total_workers = cart_workers * carts + trolley_workers * trolleys;

% Meet or exceed the required transport rate
constraint
  cart_capacity * carts + trolley_capacity * trolleys >= required_rate;

% Minimum number of trolleys to be used
constraint
  trolleys >= min_trolleys;

% At most 40% of transported capacity can be via trolleys:
% trolley_capacity*trolleys <= max_trolley_fraction * (cart_capacity*carts + trolley_capacity*trolleys)
% Use integer arithmetic to avoid float coercion: 7t <= 0.4*(5c+7t)  <=>  42t <= 10c+14t  <=>  28t <= 10c
constraint
  (trolley_capacity * 10) * trolleys <= (cart_capacity * 4) * carts;

% Objective
solve minimize total_workers;