% Toy store shipping optimization (all data embedded)

% Data
int: gifts_per_new = 50;
int: gifts_per_old = 70;

int: diesel_per_new = 30;
int: diesel_per_old = 40;

int: required_gifts = 1000;
int: max_new_trips = 15;

% Decision variables: number of trips by each company
var 0..max_new_trips: new_trips;
var 0..1000: old_trips; % safe upper bound

% Constraints
constraint gifts_per_new * new_trips + gifts_per_old * old_trips >= required_gifts;

% At least 40% of all trips are made by the old company:
% old_trips / (new_trips + old_trips) >= 0.4
% => 10*old_trips >= 4*(new_trips + old_trips) => 6*old_trips >= 4*new_trips
constraint 6 * old_trips >= 4 * new_trips;

% Objective: minimize total diesel
var int: total_diesel = diesel_per_new * new_trips + diesel_per_old * old_trips;
solve minimize total_diesel;

output [
  "new_trips = ", show(new_trips), "\n",
  "old_trips = ", show(old_trips), "\n",
  "total_diesel = ", show(total_diesel), "\n",
  "total_gifts = ", show(gifts_per_new * new_trips + gifts_per_old * old_trips), "\n"
];