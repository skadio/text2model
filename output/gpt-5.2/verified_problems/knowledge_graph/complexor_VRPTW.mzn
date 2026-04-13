include "globals.mzn";

int: CustomerCount;
int: VehicleCount;

set of int: C = 1..CustomerCount;
set of int: V = 1..VehicleCount;

array[C] of int: CustomerDemand;
array[C] of int: CustomerLBTW;
array[C] of int: CustomerUBTW;
array[C] of int: CustomerServiceTime;
array[C,C] of int: CustomerDistance;

array[V] of int: VehicleCapacity;

% Decision variables:
% vehicle serving each customer
array[C] of var V: vehicle_of;

% predecessor and successor within each vehicle route (customers only; no depot nodes)
% 0 denotes "none" (route start/end)
array[C] of var 0..CustomerCount: pred;
array[C] of var 0..CustomerCount: succ;

% service start time at each customer
array[C] of var int: start_time;

% ---- Basic structural constraints (VRP without explicit depot nodes) ----

% No self-loops
constraint forall(i in C) (pred[i] != i /\ succ[i] != i);

% Each customer has at most one predecessor and at most one successor.
constraint alldifferent_except_0(pred);
constraint alldifferent_except_0(succ);

% Flow consistency: pred and succ are inverse mappings (ignoring 0)
constraint
  forall(i in C) (
    (pred[i] = 0) \/ (succ[pred[i]] = i)
  )
  /\
  forall(i in C) (
    (succ[i] = 0) \/ (pred[succ[i]] = i)
  );

% Vehicles must be consistent along arcs
constraint forall(i in C where succ[i] != 0) (vehicle_of[i] = vehicle_of[succ[i]]);
constraint forall(i in C where pred[i] != 0) (vehicle_of[i] = vehicle_of[pred[i]]);

% Each vehicle has at most one route start (customer with pred = 0)
constraint forall(k in V) (sum(i in C)(bool2int(vehicle_of[i] = k /\ pred[i] = 0)) <= 1);

% ---- Capacity constraints ----
constraint forall(k in V) (
  sum(i in C)(CustomerDemand[i] * bool2int(vehicle_of[i] = k)) <= VehicleCapacity[k]
);

% ---- Time windows and travel/service time constraints ----
constraint forall(i in C) (
  start_time[i] >= CustomerLBTW[i] /\ start_time[i] <= CustomerUBTW[i]
);

% Propagate times along used arcs:
constraint forall(i in C where succ[i] != 0) (
  start_time[succ[i]] >= start_time[i] + CustomerServiceTime[i] + CustomerDistance[i, succ[i]]
);

% ---- Objective: minimize total travel cost between consecutive customers ----
var int: total_cost = sum(i in C)(
  (succ[i] = 0) ? 0 : CustomerDistance[i, succ[i]]
);

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "vehicle_of=", show(vehicle_of), "\n",
  "pred=", show(pred), "\n",
  "succ=", show(succ), "\n",
  "start_time=", show(start_time), "\n"
];