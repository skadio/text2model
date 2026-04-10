% Parameters (with values embedded)
int: mail_required = 1000;

int: cap_regular = 20;
int: gas_regular = 10;

int: cap_speed = 30;
int: gas_speed = 20;

int: max_regular_trips = 20;

% Variables
var 0..max_regular_trips: regular_trips;
var 0..1000: speed_trips; % safe upper bound

% Constraints
constraint cap_regular * regular_trips + cap_speed * speed_trips >= mail_required;

% At least 50% of the trips must be speed boats:
% speed_trips / (regular_trips + speed_trips) >= 0.5  <=>  speed_trips >= regular_trips
constraint speed_trips >= regular_trips;

% Objective
var int: total_gas = gas_regular * regular_trips + gas_speed * speed_trips;
solve minimize total_gas;