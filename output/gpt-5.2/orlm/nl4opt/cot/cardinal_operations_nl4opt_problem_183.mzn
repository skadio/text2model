% Parameters (with values embedded)
int: cap_large = 2000;
int: cap_small = 800;
int: pol_large = 20;
int: pol_small = 15;

int: max_large_trips = 7;
int: min_customers = 20000;

% Variables
var 0..max_large_trips: large_trips;
var 0..100: small_trips; % safe explicit upper bound

% Constraints
constraint cap_large * large_trips + cap_small * small_trips >= min_customers;

% At least 40% of total trips are small:
% small_trips >= 0.4 * (large_trips + small_trips)
% 5*small_trips >= 2*(large_trips + small_trips)  -> 3*small_trips >= 2*large_trips
constraint 3 * small_trips >= 2 * large_trips;

% Tighten small_trips bound based on feasibility (optional but safe)
constraint small_trips <= 30; % 30 small trips alone can carry 24000 customers

% Objective
solve minimize pol_large * large_trips + pol_small * small_trips;