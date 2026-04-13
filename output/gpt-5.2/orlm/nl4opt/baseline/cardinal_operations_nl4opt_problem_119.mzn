% Mail delivery by regular and speed boats: minimize total gas

int: mail_required = 1000;

int: cap_regular = 20;
int: gas_regular = 10;

int: cap_speed = 30;
int: gas_speed = 20;

int: max_regular_trips = 20;

var 0..1000: r; % regular trips
var 0..1000: s; % speed trips

% Objective: minimize total gas
var int: total_gas = gas_regular * r + gas_speed * s;

constraint r <= max_regular_trips;

% Must deliver at least required mail
constraint cap_regular * r + cap_speed * s >= mail_required;

% At least 50% of trips must be speed boats: s >= 0.5*(r+s) <=> s >= r
constraint s >= r;

solve minimize total_gas;

output [
  "regular_trips = ", show(r), "\n",
  "speed_trips   = ", show(s), "\n",
  "total_mail    = ", show(cap_regular*r + cap_speed*s), "\n",
  "total_gas     = ", show(total_gas), "\n"
];