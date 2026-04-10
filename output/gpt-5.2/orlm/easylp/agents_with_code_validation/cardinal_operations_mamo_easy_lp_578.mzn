% Parameters
int: max_total_investment = 50;          % Total investment limit across all property types (units)
int: min_portfolio_score = 30;           % Minimum required portfolio score: 2x + 3y + z
int: max_diff_res_comm = 10;             % Maximum allowed difference between residential and commercial investments
int: min_comm_over_ind = 5;              % Commercial investment must be at least this many units more than industrial

int: cost_residential = 500;             % Cost per unit of residential investment ($)
int: cost_commercial  = 700;             % Cost per unit of commercial investment ($)
int: cost_industrial  = 900;             % Cost per unit of industrial investment ($)

% No explicit individual upper limits beyond the total limit; use total limit as per-type cap
int: max_residential = max_total_investment;
int: max_commercial  = max_total_investment;
int: max_industrial  = max_total_investment;

% Variables
var 0..max_residential: x;               % Residential investment units
var 0..max_commercial:  y;               % Commercial investment units
var 0..max_industrial:  z;               % Industrial investment units

% Upper bound on cost derived from per-type caps (safe, though loose)
var 0..(cost_residential*max_residential
      + cost_commercial*max_commercial
      + cost_industrial*max_industrial): total_cost; % Total cost ($)

% Constraints
constraint x + y + z <= max_total_investment;

constraint 2 * x + 3 * y + z >= min_portfolio_score;

constraint abs(x - y) <= max_diff_res_comm;

constraint y >= z + min_comm_over_ind;

constraint total_cost = cost_residential * x
                      + cost_commercial  * y
                      + cost_industrial  * z;

% Objective
solve minimize total_cost;