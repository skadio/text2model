% Parameters
int: D;                                  % Number of ports
int: P;                                  % Number of depots

array[1..P] of int: Numdepot;            % Containers currently available at each depot (supply)
array[1..D] of int: Numport;             % Minimum containers required at each port (demand)

float: Price;                            % Cost per unit distance per barge
array[1..D, 1..P] of float: Distance;    % Distance between port d and depot p

% Variables
array[1..D, 1..P] of var int: Barges;    % Number of barges sent from depot p to port d (each holds 2 containers)
array[1..D, 1..P] of var int: Ship;      % Number of containers shipped from depot p to port d

% Constraints

% Link shipped containers to number of barges (each barge carries exactly 2 containers)
constraint
  forall(d in 1..D, p in 1..P) (
    Ship[d, p] = 2 * Barges[d, p]
  );

% Demand satisfaction at each port: received containers must meet or exceed required minimum
constraint
  forall(d in 1..D) (
    sum(p in 1..P)(Ship[d, p]) >= Numport[d]
  );

% Supply limitation at each depot: total shipped containers cannot exceed available containers
constraint
  forall(p in 1..P) (
    sum(d in 1..D)(Ship[d, p]) <= Numdepot[p]
  );

% Non-negativity of shipment decisions
constraint
  forall(d in 1..D, p in 1..P) (
    Barges[d, p] >= 0 /\ Ship[d, p] >= 0
  );

% Objective
solve minimize
  sum(d in 1..D, p in 1..P)( Price * Distance[d, p] * Barges[d, p] );