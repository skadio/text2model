% Parameters
int: ndepts;                        % Number of departments
int: ncities;                       % Number of cities
int: ncitiesm1;                     % Number of cities excluding the host city (given in data)

set of int: DEPTS  = 1..ndepts;     % Department index set
set of int: CITIES = 1..ncities;    % City index set

array[DEPTS, CITIES] of int: benefit;   % benefit[d,c]: benefit (£k) of locating department d in city c
array[CITIES, CITIES] of float: dist;   % dist[c1,c2]: communication cost per unit (£) between cities (can be float)
array[DEPTS, DEPTS] of int: comm;       % comm[d1,d2]: communication quantity (k units) between departments

% Variables
array[DEPTS] of var CITIES: loc;          % loc[d]: chosen city for department d
array[DEPTS, CITIES] of var 0..1: x;      % x[d,c] = 1 iff department d is located in city c
array[CITIES] of var 0..3: city_load;     % number of departments assigned to each city (capacity max 3)

var int: total_benefit;                   % total benefit component (£k)
var float: total_comm_cost;               % total communication cost component
var float: total_savings;                 % objective = total_benefit - total_comm_cost

% Constraints

% Each department assigned to exactly one city via x
constraint forall(d in DEPTS) (
  sum(c in CITIES)(x[d,c]) = 1
);

% Channeling between loc and x
constraint forall(d in DEPTS, c in CITIES) (
  x[d,c] = bool2int(loc[d] = c)
);

% City load definition and capacity (at most 3 departments per city)
constraint forall(c in CITIES) (
  city_load[c] = sum(d in DEPTS)(x[d,c])
);
constraint forall(c in CITIES) (
  city_load[c] <= 3
);

% Total benefit: sum of benefits for chosen locations
constraint total_benefit =
  sum(d in DEPTS, c in CITIES)(
    benefit[d,c] * x[d,c]
  );

% Total communication cost: sum over unordered department pairs to avoid double counting
% Cost for a pair (d1,d2) is comm[d1,d2] * dist[loc[d1], loc[d2]]
constraint total_comm_cost =
  sum(d1 in DEPTS, d2 in DEPTS where d1 < d2)(
    (comm[d1,d2] * 1.0) * dist[loc[d1], loc[d2]]
  );

% Total savings definition
constraint total_savings = total_benefit * 1.0 - total_comm_cost;

% Objective
solve maximize total_savings;