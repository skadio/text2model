% Parameters
int: ndepts;                      % number of departments
int: ncities;                     % number of cities (including the host city)
int: ncitiesm1;                   % number of non-host candidate cities (as given in data)

set of int: DEPTS  = 1..ndepts;   % department indices
set of int: CITIES = 1..ncities;  % city indices

array[DEPTS, CITIES] of int: benefit;   % benefit (£k) for placing each department in each city
array[CITIES, CITIES] of int: dist;     % communication cost per unit (£) between cities
array[DEPTS, DEPTS] of int: comm;       % communication quantity (k units) between departments


% Variables
array[DEPTS] of var CITIES: loc;         % loc[d] = city where department d is located
array[DEPTS, CITIES] of var 0..1: x;     % x[d,c] = 1 iff department d is assigned to city c

var int: total_benefit;                  % total benefit (£k) from department locations
var int: total_comm_cost;                % total communication cost
var int: total_savings;                  % objective: total_benefit - total_comm_cost


% Constraints
%------------------------------------------------------------
% Linking constraints: loc <-> x (assignment matrix)
%------------------------------------------------------------
constraint
  forall(d in DEPTS) (
    % Each department is assigned to exactly one city
    sum(c in CITIES)(x[d,c]) = 1
  );

constraint
  forall(d in DEPTS, c in CITIES) (
    % x[d,c] indicates whether loc[d] equals city c
    x[d,c] = bool2int(loc[d] = c)
  );

%------------------------------------------------------------
% Capacity constraints: at most 3 departments per city
%------------------------------------------------------------
constraint
  forall(c in CITIES) (
    sum(d in DEPTS)(x[d,c]) <= 3
  );

%------------------------------------------------------------
% Total benefit computation
%------------------------------------------------------------
constraint
  total_benefit =
    sum(d in DEPTS, c in CITIES) (benefit[d,c] * x[d,c]);

%------------------------------------------------------------
% Total communication cost computation
% Counts each unordered pair of departments once to avoid double counting
%------------------------------------------------------------
constraint
  total_comm_cost =
    sum(d1 in DEPTS, d2 in d1+1..ndepts, c1 in CITIES, c2 in CITIES) (
      comm[d1,d2] * dist[c1,c2] * x[d1,c1] * x[d2,c2]
    );

%------------------------------------------------------------
% Savings definition
%------------------------------------------------------------
constraint
  total_savings = total_benefit - total_comm_cost;


% Objective
solve maximize total_savings;