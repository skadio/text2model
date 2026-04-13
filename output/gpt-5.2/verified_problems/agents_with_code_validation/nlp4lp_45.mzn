% Parameters
int: D;                                  % Number of ports
int: P;                                  % Number of depots

array[1..P] of int: Numdepot;            % Containers currently available at each depot
array[1..D] of int: Numport;             % Minimum containers required at each port

float: Price;                            % Cost per unit distance for transporting goods
array[1..D, 1..P] of float: Distance;    % Distance between port d and depot p

% Variables
array[1..D, 1..P] of var 0..max(Numdepot) div 2: Barges;  % Barges from depot p to port d (2 containers each)
array[1..D, 1..P] of var 0..max(Numdepot): Ship;          % Containers shipped from depot p to port d
var float: TotalCost;                                     % Total transportation cost

% Constraints
% --- Link shipped containers to barge capacity (2 containers per barge) ---
constraint
  forall(d in 1..D, p in 1..P) (
    Ship[d,p] = 2 * Barges[d,p]
  );

% --- Depot supply constraints: cannot ship more containers than available at each depot ---
constraint
  forall(p in 1..P) (
    sum(d in 1..D)(Ship[d,p]) <= Numdepot[p]
  );

% --- Port demand constraints: each port must receive at least its requirement ---
constraint
  forall(d in 1..D) (
    sum(p in 1..P)(Ship[d,p]) >= Numport[d]
  );

% --- Total transportation cost computation (cost proportional to distance and number of barges) ---
constraint
  TotalCost =
    sum(d in 1..D, p in 1..P) (Price * Distance[d,p] * int2float(Barges[d,p]));

% Objective
solve minimize TotalCost;