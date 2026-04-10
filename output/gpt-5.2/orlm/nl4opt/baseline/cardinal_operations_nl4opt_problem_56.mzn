int: demand = 150000;
int: tech_available = 160;

int: flow_high = 10000;
int: flow_low  = 5000;

int: tech_high = 12;
int: tech_low  = 5;

float: max_high_fraction = 0.35;
int: min_low_pipes = 8;

% Decision variables
var 0..1000: high;
var min_low_pipes..1000: low;

% Total pipes
var 0..2000: total = high + low;

% Demand constraint
constraint flow_high * high + flow_low * low >= demand;

% Technician constraint
constraint tech_high * high + tech_low * low <= tech_available;

% At most 35% of pipes are high-volume:
% high <= 0.35 * total  ->  100*high <= 35*(high+low)
constraint 100 * high <= 35 * (high + low);

solve minimize total;

output [
  "high_volume_pipes = ", show(high), "\n",
  "low_volume_pipes  = ", show(low), "\n",
  "total_pipes       = ", show(total), "\n",
  "total_flow        = ", show(flow_high*high + flow_low*low), "\n",
  "techs_used        = ", show(tech_high*high + tech_low*low), "\n"
];