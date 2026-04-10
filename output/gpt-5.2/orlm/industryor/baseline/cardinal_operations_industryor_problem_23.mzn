% Transportation planning with mutual exclusivity and pollution minimization

int: demand = 1800;
int: pollution_limit = 2000;

set of int: MODES = 1..4;
int: TRUCK = 1;
int: VAN   = 2;
int: MOTO  = 3;
int: EV    = 4;

array[MODES] of int: cap = [100, 80, 40, 60];
array[MODES] of int: pol = [100, 50, 10, 0];

% Upper bounds derived from demand (safe, tight enough)
array[MODES] of int: ub = [
  (demand div cap[TRUCK]) + 20,  % truck
  (demand div cap[VAN])   + 20,  % van
  (demand div cap[MOTO])  + 50,  % motorcycle
  (demand div cap[EV])    + 20   % EV
];

array[MODES] of var 0..max(ub): trips;

% At least 10 truck trips
constraint trips[TRUCK] >= 10;

% Either vans or EVs, but not both
var bool: use_van = trips[VAN] > 0;
var bool: use_ev  = trips[EV]  > 0;
constraint use_van + use_ev <= 1;

% Deliver at least the demand
constraint sum(m in MODES)(cap[m] * trips[m]) >= demand;

% Pollution limit
var int: total_pollution = sum(m in MODES)(pol[m] * trips[m]);
constraint total_pollution <= pollution_limit;

solve minimize total_pollution;

output [
  "Minimum total pollution = ", show(total_pollution), "\n",
  "Trips: truck=", show(trips[TRUCK]),
  ", van=", show(trips[VAN]),
  ", motorcycle=", show(trips[MOTO]),
  ", EV=", show(trips[EV]), "\n",
  "Total delivered = ", show(sum(m in MODES)(cap[m] * trips[m])), "\n"
];