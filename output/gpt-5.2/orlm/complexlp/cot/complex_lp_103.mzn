% Parameters (with values embedded)
int: N = 8;
set of int: Cities = 0..N-1;
int: Source = 0;
int: Sink = 7;

array[Cities, Cities] of int: cap =
array2d(Cities, Cities,
[
  % to: 0  1  2  3  4  5  6  7
      0,11, 1, 6, 4, 5, 7, 1,  % from 0
      3, 0,15,15,16, 9,14,12,  % from 1
     19, 9, 0, 5, 9,11,16, 3,  % from 2
     15, 1,14, 0, 0, 4, 1,15,  % from 3
      8,16, 7, 3, 0,16,10,11,  % from 4
      7, 8, 1,11,19, 0, 3, 3,  % from 5
      2,19, 2, 6,12,20, 0, 6,  % from 6
     15,17, 4, 7, 8, 2,16, 0   % from 7
]);

% Variables
array[Cities, Cities] of var 0..20: f; % flow on each directed road (upper bounded by max cap)

% Constraints
constraint forall(i,j in Cities) (
  f[i,j] <= cap[i,j]
);

% Flow conservation for all intermediate nodes
constraint forall(v in Cities where v != Source /\ v != Sink) (
  sum(i in Cities)(f[i,v]) = sum(j in Cities)(f[v,j])
);

% No self-loop flow (optional clarity)
constraint forall(i in Cities) (f[i,i] = 0);

% Objective
var int: total_flow = sum(j in Cities)(f[Source,j]) - sum(i in Cities)(f[i,Source]);

solve maximize total_flow;

output [
  "Maximum supplies from City ", show(Source), " to City ", show(Sink), ": ",
  show(total_flow), " tons/day\n"
];