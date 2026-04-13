% Currency exchange optimization with per-currency daily limits
% Uses bounded float variables to avoid Gecode Float::linear "Number out of limits"

int: N;                                   % Number of different currencies
set of int: C = 1..N;                     % Currency index set

array[C] of float: Start;                 % Initial amount of each currency
array[C] of float: Limit;                 % Daily exchange limit per currency (total in+out)
array[C, C] of float: Rate;               % Exchange rate from currency i to currency j

% A safe global bound for all exchange decision variables.
% Outgoing in currency i is limited by both Start[i] and Limit[i].
float: XMAX = max([ min(Start[i], Limit[i]) | i in C ]);

% Decision variables: x[i,j] is amount (in units of i) exchanged from i to j
array[C, C] of var 0.0..XMAX: x;

% End-of-day holdings; bounded to keep linear constraints within solver limits
array[C] of var 0.0..(max(Start) + max(Limit)): endAmt;

%-----------------------------
% No self-exchange
%-----------------------------
constraint forall(i in C) ( x[i,i] = 0.0 );

%-----------------------------
% Daily exchange limit per currency (total in + out, measured in that currency)
% Outgoing is in units of i; incoming is converted into units of i via Rate[j,i]
%-----------------------------
constraint
  forall(i in C) (
    sum(j in C) ( x[i,j] )
    +
    sum(j in C) ( x[j,i] * Rate[j,i] )
    <= Limit[i]
  );

%-----------------------------
% Feasibility: cannot exchange out more than initially available
%-----------------------------
constraint
  forall(i in C) (
    sum(j in C) ( x[i,j] ) <= Start[i]
  );

%-----------------------------
% End-of-day holdings balance for each currency
%-----------------------------
constraint
  forall(i in C) (
    endAmt[i]
    =
    Start[i]
    + sum(j in C) ( x[j,i] * Rate[j,i] )
    - sum(j in C) ( x[i,j] )
  );

% Objective: maximize total final units across all currencies
solve maximize sum(i in C)(endAmt[i]);