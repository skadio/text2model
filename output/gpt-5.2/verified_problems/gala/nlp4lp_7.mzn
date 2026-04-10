include "globals.mzn";

%----------------------------
% Input data
%----------------------------
int: X0;   % initial position
int: V0;   % initial velocity
int: XT;   % target position at time T
int: VT;   % target velocity at time T
int: T;    % number of time steps (target time)

%----------------------------
% Decision variables
%----------------------------
% States at times 0..T
array[0..T] of var int: x;
array[0..T] of var int: v;

% Controls at times 0..T-1
array[0..T-1] of var int: a;

% Objective: minimize maximum absolute acceleration
var 0..maxint: M;  % max_t |a_t|

%----------------------------
% Constraints
%----------------------------
% Initial conditions
constraint x[0] = X0;
constraint v[0] = V0;

% Dynamics (time increment = 1)
constraint forall(t in 0..T-1) (
  x[t+1] = x[t] + v[t] /\
  v[t+1] = v[t] + a[t]
);

% Terminal conditions
constraint x[T] = XT;
constraint v[T] = VT;

% Define max absolute acceleration
constraint forall(t in 0..T-1) (
  M >= a[t] /\
  M >= -a[t]
);

%----------------------------
% Solve
%----------------------------
solve minimize M;

%----------------------------
% Output
%----------------------------
output [
  "M = ", show(M), "\n",
  "a = ", show(a), "\n",
  "x = ", show(x), "\n",
  "v = ", show(v), "\n"
];