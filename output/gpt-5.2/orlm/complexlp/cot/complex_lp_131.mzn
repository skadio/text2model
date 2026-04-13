% Parameters (with values embedded)
int: N = 7;
set of int: CITIES = 0..N-1;
int: source = 0;
int: sink = 6;

array[CITIES, CITIES] of int: cap =
[|  0, 18000, 11000, 15000,  2000,  4000, 20000
 | 4000,     0,  6000,  5000, 19000, 15000,     0
 |15000, 10000,     0,  7000,     0,  7000,  5000
 |14000,  5000,  3000,     0, 10000, 15000, 19000
 | 2000, 11000,  1000, 10000,     0, 14000,  6000
 |10000, 14000,  6000,  5000,  3000,     0, 18000
 | 8000,  1000, 11000,  8000,  6000, 20000,     0 |];

int: MAXCAP = max([cap[i,j] | i in CITIES, j in CITIES]);

% Variables
array[CITIES, CITIES] of var 0..MAXCAP: f;  % passenger flow on each directed rail line
var 0..(N*MAXCAP): total_flow;

% Constraints
constraint
  forall(i in CITIES, j in CITIES) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(v in CITIES where v != source /\ v != sink) (
    sum(j in CITIES)(f[v,j]) = sum(i in CITIES)(f[i,v])
  );

constraint
  total_flow = sum(j in CITIES)(f[source,j]) - sum(i in CITIES)(f[i,source]);

constraint
  total_flow = sum(i in CITIES)(f[i,sink]) - sum(j in CITIES)(f[sink,j]);

% Objective
solve maximize total_flow;