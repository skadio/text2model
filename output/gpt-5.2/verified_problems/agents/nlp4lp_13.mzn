% Parameters
int: N;                                    % Number of different currencies
set of int: C = 1..N;                      % Currency index set

array[C] of float: Start;                  % Initial amount held of currency i
array[C] of float: Limit;                  % Daily total exchange limit for currency i (in/out)
array[C, C] of float: Rate;                % Exchange rate from currency i to currency j


% Variables
array[C, C] of var float: x;               % Amount of currency i exchanged into currency j (in units of currency i)
array[C] of var float: endAmt;             % End-of-day amount held of currency i
var float: totalEnd;                       % Total end-of-day amount (sum of endAmt)


% Constraints
% Non-negativity (no negative exchanges / holdings)
constraint forall(i in C, j in C) ( x[i,j] >= 0.0 );
constraint forall(i in C) ( endAmt[i] >= 0.0 );

% 1) Flow conservation / end-of-day holdings
%    endAmt[i] = Start[i] - total outgoing from i + total incoming converted into i
constraint
  forall(i in C) (
    endAmt[i]
    =
    Start[i]
    - sum(j in C) ( x[i,j] )
    + sum(j in C) ( x[j,i] * Rate[j,i] )
  );

% 2) Cannot exchange more of a currency than available at start (no borrowing/shorting intra-day)
constraint
  forall(i in C) (
    sum(j in C) ( x[i,j] ) <= Start[i]
  );

% 3) Daily regulation limit per currency (total exchanged out of currency i)
constraint
  forall(i in C) (
    sum(j in C) ( x[i,j] ) <= Limit[i]
  );

% 4) Aggregate end-of-day wealth variable
constraint
  totalEnd = sum(i in C) ( endAmt[i] );


% Objective
solve maximize totalEnd;