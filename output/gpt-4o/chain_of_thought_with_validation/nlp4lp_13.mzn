% Parameters
int: N;
array[1..N] of float: Start;
array[1..N] of float: Limit;
array[1..N, 1..N] of float: Rate;

% -------------------------------------------------------------------------
% Derived finite bounds (needed by most float solvers)
% -------------------------------------------------------------------------
float: maxLimit  = max([ Limit[i] | i in 1..N ]);
float: maxRate   = max([ Rate[i,j] | i in 1..N, j in 1..N ]);
float: totalLimit = sum(i in 1..N)( Limit[i] );
float: maxFinal  = max([ Start[i] + maxRate * totalLimit | i in 1..N ]);

% -------------------------------------------------------------------------
% Decision variables
% -------------------------------------------------------------------------
array[1..N, 1..N] of var 0.0..maxLimit: X;      % amount exchanged from i to j
array[1..N]            of var 0.0..maxFinal: Final;  % final holdings

% -------------------------------------------------------------------------
% Constraints
% -------------------------------------------------------------------------
% 1) No self–exchange
constraint
  forall(i in 1..N)( X[i,i] = 0.0 );

% 2) Balance equation for each currency
constraint
  forall(i in 1..N)(
    Final[i] = Start[i]
               - sum(j in 1..N)( X[i,j] )
               + sum(j in 1..N)( Rate[j,i] * X[j,i] )
  );

% 3) Daily transaction limits for each currency
constraint
  forall(i in 1..N)(
    sum(j in 1..N)( X[i,j] ) + sum(j in 1..N)( X[j,i] ) <= Limit[i]
  );

% -------------------------------------------------------------------------
% Objective: maximise total wealth at the end of the day
% -------------------------------------------------------------------------
solve maximize sum(i in 1..N)( Final[i] );