% Parameters
int: D;                                   % Number of ports
int: P;                                   % Number of depots

set of int: Ports  = 1..D;
set of int: Depots = 1..P;

array[Depots] of int: Numdepot;           % Containers available at each depot
array[Ports] of int: Numport;             % Containers required at each port

float: Price;                             % Cost per distance unit
array[Ports, Depots] of float: Distance;  % Distance between depot i and port j
                                          
% Auxiliary constants
int: MaxAvailable = max(Numdepot);        % Maximum stock at any depot
int: MaxBarge     = MaxAvailable div 2;   % Corresponding upper bound on barges

% Variables
array[Depots, Ports] of var 0..MaxBarge: y;   % y[i,j] = barges sent from depot i to port j

% Constraints
constraint
  forall(i in Depots)(
    sum(j in Ports)(2 * y[i,j]) <= Numdepot[i]      % Do not ship more than available
  );

constraint
  forall(j in Ports)(
    sum(i in Depots)(2 * y[i,j]) >= Numport[j]      % Satisfy port demand
  );

% Objective
var float: TotalCost =
  sum(i in Depots, j in Ports)(
      Price * Distance[j,i] * int2float(y[i,j])
  );

solve minimize TotalCost;