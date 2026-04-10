% Parameters
int: large_capacity = 2000;
int: small_capacity = 800;
int: large_pollution = 20;
int: small_pollution = 15;

int: max_large_trips = 7;
int: min_customers = 20000;

% Variables
var 0..max_large_trips: large_trips;
var 0..100: small_trips; % safe upper bound; tightened by demand constraint

% Constraints
constraint large_capacity * large_trips + small_capacity * small_trips >= min_customers;

% At least 40% of total trips are small:
% small_trips >= 0.4*(large_trips + small_trips)  <=>  3*small_trips >= 2*large_trips
constraint 3 * small_trips >= 2 * large_trips;

% Objective
solve minimize large_pollution * large_trips + small_pollution * small_trips;