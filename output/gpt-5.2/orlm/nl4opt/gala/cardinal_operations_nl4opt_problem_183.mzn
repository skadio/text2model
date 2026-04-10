include "globals.mzn";

% Data (embedded)
int: cap_large = 2000;
int: pol_large = 20;
int: cap_small = 800;
int: pol_small = 15;

int: max_large = 7;
int: min_customers = 20000;

% Decision variables
var 0..max_large: large_trips;

% Upper bound for small trips: if all were small, need ceil(20000/800)=25
var 0..25: small_trips;

% Constraints
constraint cap_large * large_trips + cap_small * small_trips >= min_customers;

% At least 40% of total trips are small:
% small_trips / (large_trips + small_trips) >= 0.4
% Avoid division: 5*small >= 2*(large+small)  => 3*small >= 2*large
constraint 3 * small_trips >= 2 * large_trips;

% Objective: minimize total pollution
var int: total_pollution = pol_large * large_trips + pol_small * small_trips;
solve minimize total_pollution;

output [
  "large_trips = ", show(large_trips), "\n",
  "small_trips = ", show(small_trips), "\n",
  "customers = ", show(cap_large * large_trips + cap_small * small_trips), "\n",
  "total_pollution = ", show(total_pollution), "\n"
];