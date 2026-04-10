% Parameters
int: premium_pages_per_min = 30;     % Pages per minute for premium printer
int: regular_pages_per_min = 20;     % Pages per minute for regular printer
int: premium_ink_per_min   = 4;      % Ink units per minute for premium printer
int: regular_ink_per_min   = 3;      % Ink units per minute for regular printer

int: min_pages_per_min = 200;        % Minimum required pages per minute
int: max_ink_per_min   = 35;         % Maximum allowed ink units per minute

% A safe upper bound on number of printers (derived from page requirement)
int: max_printers = min_pages_per_min div min(premium_pages_per_min, regular_pages_per_min);

% Variables
var 0..max_printers: num_premium;    % Number of premium printers to buy
var 0..max_printers: num_regular;    % Number of regular printers to buy

% Constraints

% --- Throughput requirement: ensure enough pages per minute ---
constraint
  premium_pages_per_min * num_premium + regular_pages_per_min * num_regular
  >= min_pages_per_min;

% --- Ink usage limit: do not exceed available ink per minute ---
constraint
  premium_ink_per_min * num_premium + regular_ink_per_min * num_regular
  <= max_ink_per_min;

% --- Preference constraint: regular printers must be fewer than premium printers ---
constraint
  num_regular < num_premium;

% Objective
solve minimize num_premium + num_regular;