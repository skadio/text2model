% Parameters
int: cap_regular = 20;
int: cap_speed   = 30;
int: gas_regular = 10;
int: gas_speed   = 20;

int: max_regular_trips = 20;
int: demand_mail = 1000;

% Variables
var 0..max_regular_trips: r;         % regular boat trips
var 0..demand_mail: s;               % speed boat trips (upper bound tightened by constraints)

% Constraints
constraint cap_regular * r + cap_speed * s >= demand_mail;

% at least 50% of total trips are speed trips: s >= 0.5*(r+s) <=> s >= r
constraint s >= r;

% tighten s bound using demand feasibility (optional but keeps domains small)
constraint s <= (demand_mail + cap_speed - 1) div cap_speed;

% Objective
solve minimize gas_regular * r + gas_speed * s;