% Cruise ship trip planning: minimize pollution while meeting demand and policy constraints.

int: cap_large = 2000;
int: pol_large = 20;

int: cap_small = 800;
int: pol_small = 15;

int: max_large_trips = 7;
int: min_customers = 20000;

% Decision variables: number of trips of each type
var 0..max_large_trips: large_trips;
var 0..100: small_trips; % safe upper bound for this instance

% Constraints
constraint cap_large * large_trips + cap_small * small_trips >= min_customers;

constraint large_trips <= max_large_trips;

% At least 40% of total trips are small:
% small_trips / (large_trips + small_trips) >= 0.4
% Equivalent linear form: 3*small_trips >= 2*large_trips
constraint 3 * small_trips >= 2 * large_trips;

% Objective: minimize total pollution
var int: total_pollution = pol_large * large_trips + pol_small * small_trips;
solve minimize total_pollution;

output [
  "large_trips = ", show(large_trips), "\n",
  "small_trips = ", show(small_trips), "\n",
  "total_customers = ", show(cap_large * large_trips + cap_small * small_trips), "\n",
  "total_pollution = ", show(total_pollution), "\n"
];