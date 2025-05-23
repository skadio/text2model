% Parameters
int: P;                                    % Number of depots
int: D;                                    % Number of ports
array[1..P] of int: Numdepot;              % Containers available at each depot
array[1..D] of int: Numport;               % Containers required at each port
float: Price;                              % Cost per unit distance per barge
array[1..D, 1..P] of float: Distance;      % Distance from depot d (column) to port p (row)

% Derived constants
int: TOTAL_SUPPLY = sum(d in 1..P)(Numdepot[d]);
int: MAX_BARGES   = (TOTAL_SUPPLY + 1) div 2;   % Upper bound on barges on any route

% Decision variables
array[1..P, 1..D] of var 0..TOTAL_SUPPLY: x;    % Containers shipped from depot d to port p
array[1..P, 1..D] of var 0..MAX_BARGES:   b;    % Barges used on route (d,p)

% Constraints
% Each barge can transport at most two containers
constraint
    forall(d in 1..P, p in 1..D) (
        2 * b[d,p] >= x[d,p]
    );

% Do not ship more than available supply from each depot
constraint
    forall(d in 1..P) (
        sum(p in 1..D)(x[d,p]) <= Numdepot[d]
    );

% Satisfy demand at each port
constraint
    forall(p in 1..D) (
        sum(d in 1..P)(x[d,p]) >= Numport[p]
    );

% Objective
var float: total_cost =
    sum(d in 1..P, p in 1..D)(
        Price * Distance[p,d] * int2float(b[d,p])
    );

solve minimize total_cost;