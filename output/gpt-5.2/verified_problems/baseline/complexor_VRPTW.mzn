int: CustomerCount;
int: VehicleCount;

set of int: C = 1..CustomerCount;
set of int: V = 1..VehicleCount;

array[C] of int: CustomerDemand;
array[C] of int: CustomerLBTW;
array[C] of int: CustomerUBTW;
array[C, C] of int: CustomerDistance;
array[C] of int: CustomerServiceTime;
array[V] of int: VehicleCapacity;

% ----------------------------
% Model: VRPTW without explicit depot node (each vehicle forms a path among customers).
% Each customer is assigned to exactly one vehicle and sequenced on that vehicle.
% Time windows are respected along the path; waiting is allowed.
% Objective minimizes total travel distance along the vehicle paths.
% ----------------------------

% Assignment: which vehicle serves customer i
array[C] of var V: veh;

% Successor/predecessor among customers (only meaningful within same vehicle).
% We enforce a path per vehicle: customers have <=1 predecessor and <=1 successor;
% and exactly one "start" (no predecessor) and one "end" (no successor) per used vehicle.
array[C] of var 0..CustomerCount: succ;  % 0 means end of route
array[C] of var 0..CustomerCount: pred;  % 0 means start of route

% Service start times
int: H = max(CustomerUBTW); % planning horizon from data
array[C] of var 0..H: start;

% Vehicle usage indicator
array[V] of var bool: used;

% ----------------------------
% Basic domains and self-loop elimination
% ----------------------------
constraint forall(i in C) (succ[i] != i /\ pred[i] != i);

% Time window constraints
constraint forall(i in C) (
  start[i] >= CustomerLBTW[i] /\ start[i] <= CustomerUBTW[i]
);

% ----------------------------
% Predecessor/successor consistency and single in/out degree
% ----------------------------
% succ and pred are inverses on customers (ignoring 0)
constraint forall(i in C) (
  (succ[i] = 0) \/ (pred[succ[i]] = i)
);
constraint forall(i in C) (
  (pred[i] = 0) \/ (succ[pred[i]] = i)
);

% Each customer has at most one predecessor and at most one successor:
constraint forall(i in C) (
  sum(j in C)(bool2int(succ[j] = i)) = bool2int(pred[i] != 0)
);
constraint forall(i in C) (
  sum(j in C)(bool2int(pred[j] = i)) = bool2int(succ[i] != 0)
);

% ----------------------------
% Vehicle linkage: edges only within same vehicle
% ----------------------------
constraint forall(i in C) (
  (succ[i] = 0) \/ (veh[succ[i]] = veh[i])
);
constraint forall(i in C) (
  (pred[i] = 0) \/ (veh[pred[i]] = veh[i])
);

% Vehicle usage: if any customer assigned then used
constraint forall(v in V) (
  used[v] <-> exists(i in C)(veh[i] = v)
);

% For each used vehicle: exactly one start and one end in its path.
constraint forall(v in V) (
  sum(i in C)(bool2int(veh[i] = v /\ pred[i] = 0)) = bool2int(used[v])
);
constraint forall(v in V) (
  sum(i in C)(bool2int(veh[i] = v /\ succ[i] = 0)) = bool2int(used[v])
);

% ----------------------------
% Capacity constraints per vehicle
% ----------------------------
constraint forall(v in V) (
  sum(i in C)(CustomerDemand[i] * bool2int(veh[i] = v)) <= VehicleCapacity[v]
);

% ----------------------------
% Time propagation along arcs
% waiting is allowed; service time at i is included before traveling to succ
% ----------------------------
constraint forall(i in C where true) (
  (succ[i] = 0) \/
  (start[succ[i]] >= start[i] + CustomerServiceTime[i] + CustomerDistance[i, succ[i]])
);

% ----------------------------
% Subtour elimination (MTZ-style) per vehicle using order variables
% ----------------------------
array[C] of var 1..CustomerCount: ord;

constraint forall(v in V, i in C where veh[i] = v /\ pred[i] = 0) (ord[i] = 1);
constraint forall(i in C) (
  (succ[i] = 0) \/ (ord[succ[i]] >= ord[i] + 1)
);

% ----------------------------
% Objective: minimize total travel distance on chosen arcs
% (No explicit depot costs included due to missing depot data.)
% ----------------------------
var int: total_cost = sum(i in C)(
  if succ[i] = 0 then 0 else CustomerDistance[i, succ[i]] endif
);

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "veh=", show(veh), "\n",
  "succ=", show(succ), "\n",
  "pred=", show(pred), "\n",
  "start=", show(start), "\n"
];