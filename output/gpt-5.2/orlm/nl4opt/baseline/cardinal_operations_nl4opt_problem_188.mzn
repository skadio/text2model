int: heat_new = 10;
int: kwh_new = 200;

int: heat_old = 15;
int: kwh_old = 250;

int: min_apartments = 200;
int: max_kwh = 3500;

int: min_new = 5;
int: max_old_percent = 35;

% Decision variables: number of furnaces
var 0..1000: new;
var 0..1000: old;

% Total furnaces
var 0..2000: total = new + old;

constraint new >= min_new;

% Must heat at least the required number of apartments
constraint heat_new * new + heat_old * old >= min_apartments;

% Electricity availability constraint
constraint kwh_new * new + kwh_old * old <= max_kwh;

% At most 35% of furnaces can be old: old/total <= 0.35
% Avoid division: 100*old <= 35*total
constraint 100 * old <= max_old_percent * total;

solve minimize total;

output [
  "new=", show(new), "\n",
  "old=", show(old), "\n",
  "total=", show(total), "\n",
  "apartments=", show(heat_new*new + heat_old*old), "\n",
  "kwh=", show(kwh_new*new + kwh_old*old), "\n"
];