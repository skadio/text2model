% Parameters (with values embedded)
int: N = 8;
set of int: H = 0..N-1;
int: source = 0;
int: sink = 7;

array[H, H] of int: cap =
%    to: 0  1  2  3  4  5  6  7
[|    0,15,19, 4, 4, 3,20,17 |  % from 0
 |    8, 0, 6, 5,20, 3,15, 1 |  % from 1
 |   11,13, 0,16,15, 7,10,13 |  % from 2
 |   17,20, 6, 0,11, 3, 2, 0 |  % from 3 (no link to 7 given)
 |   10,15, 5, 0, 0, 9, 9,15 |  % from 4 (no link to 3 given)
 |    9,17, 5, 1, 9, 0,20, 2 |  % from 5
 |    4,16,10, 2, 1, 6, 0, 4 |  % from 6
 |    0, 0, 0, 0, 0, 0, 0, 0 |  % from 7 (no outgoing arcs specified)
 |];

int: maxCap = max([cap[i,j] | i in H, j in H]);

% Variables
array[H, H] of var 0..maxCap: f;   % flow on each directed arc
var 0..(N*maxCap): F;              % total s-t flow value

% Constraints
constraint
  forall(i in H, j in H) (
    f[i,j] <= cap[i,j]
  );

% Flow conservation (excluding source and sink)
constraint
  forall(v in H where v != source /\ v != sink) (
    sum(i in H)(f[i,v]) = sum(j in H)(f[v,j])
  );

% Define objective flow value as net outflow from source (and equivalently net inflow to sink)
constraint
  F = sum(j in H)(f[source,j]) - sum(i in H)(f[i,source]);

constraint
  F = sum(i in H)(f[i,sink]) - sum(j in H)(f[sink,j]);

% Objective
solve maximize F;