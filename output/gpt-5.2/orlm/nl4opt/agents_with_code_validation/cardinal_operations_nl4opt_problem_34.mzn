% Parameters
int: cart_rate = 5;               % kg/min transported by one cart
int: cart_workers = 2;            % workers required per cart
int: trolley_rate = 7;            % kg/min transported by one trolley
int: trolley_workers = 4;         % workers required per trolley

int: min_trolleys = 12;           % at least this many trolleys must be used
int: required_rate = 100;         % total required transport rate (kg/min)

int: max_trolley_share_num = 40;  % max trolley share numerator (percent)
int: max_trolley_share_den = 100; % max trolley share denominator

% Safe upper bounds for decision variables (sufficiently large for feasibility/optimality)
int: max_trolleys = 100;
int: max_carts = 100;


% Variables
var 0..max_carts: num_carts;                    % number of carts used
var min_trolleys..max_trolleys: num_trolleys;   % number of trolleys used

% Total workers implied by chosen numbers of carts/trolleys
var 0..(cart_workers*max_carts + trolley_workers*max_trolleys): total_workers;


% Constraints
% --- Worker accounting (link total workers to chosen vehicles) ---
constraint
  total_workers = cart_workers * num_carts + trolley_workers * num_trolleys;

% --- Required overall transport capacity (kg/min) ---
constraint
  cart_rate * num_carts + trolley_rate * num_trolleys >= required_rate;

% --- Minimum number of trolleys required ---
constraint
  num_trolleys >= min_trolleys;

% --- Trolley share limit: at most 40% of total transport rate comes from trolleys ---
% Enforced without floats via cross-multiplication:
% trolley_rate*num_trolleys <= (max_trolley_share_num/max_trolley_share_den) * total_rate
constraint
  max_trolley_share_den * trolley_rate * num_trolleys
    <= max_trolley_share_num * (cart_rate * num_carts + trolley_rate * num_trolleys);


% Objective
solve minimize total_workers;

% (Optional) Output for inspection
output [
  "num_carts=", show(num_carts), "\n",
  "num_trolleys=", show(num_trolleys), "\n",
  "total_rate=", show(cart_rate*num_carts + trolley_rate*num_trolleys), " kg/min\n",
  "total_workers=", show(total_workers), "\n"
];