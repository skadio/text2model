% Parameters
int: ndepts;                    % Number of departments
int: ncities;                   % Number of cities (including the host city)
int: ncitiesm1;                 % Number of cities excluding the host city (may remain unused)

set of int: Depts  = 1..ndepts;
set of int: Cities = 1..ncities;

array[Depts, Cities] of int: benefit;          % Benefit of locating each department in each city
array[Cities, Cities] of int: dist;            % Communication cost per unit between cities
array[Depts, Depts] of int: comm;              % Quantity of communication between departments


% Variables
array[Depts] of var Cities: loc;               % City chosen for each department


% Constraints
constraint
    forall(c in Cities)(
        sum(d in Depts)(bool2int(loc[d] = c)) <= 3     % Capacity: max 3 departments per city
    );


% Objective
var int: total_benefit =
    sum(d in Depts)( benefit[d, loc[d]] );

var int: total_comm_cost =
    sum(d1 in Depts, d2 in d1+1..ndepts)(
        comm[d1, d2] * dist[loc[d1], loc[d2]]
    );

solve maximize total_benefit - total_comm_cost;