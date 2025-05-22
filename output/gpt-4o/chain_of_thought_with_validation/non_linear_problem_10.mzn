int: ndepts;                       % number of departments
int: ncities;                      % number of cities (including the host)
int: ncitiesm1;                    % number of cities excluding the host (may be unused)

array[1..ndepts, 1..ncities] of float: benefit;   % benefit[d,c]
array[1..ncities, 1..ncities] of float: dist;     % communication cost between cities
array[1..ndepts, 1..ndepts] of float: comm;       % communication amount between departments

int: max_cap_per_city = 3;                         % capacity per city

array[1..ndepts] of var 1..ncities: loc;           % city chosen for each department

constraint
  forall(c in 1..ncities)(
    sum(d in 1..ndepts)(bool2int(loc[d] == c)) <= max_cap_per_city
  );

var float: total_benefit = 
  sum(d in 1..ndepts)(benefit[d, loc[d]]);

var float: total_comm_cost =
  sum(d1 in 1..ndepts, d2 in d1+1..ndepts)(
    comm[d1, d2] * dist[loc[d1], loc[d2]]
  );

var float: total_savings = total_benefit - total_comm_cost;

solve maximize total_savings;