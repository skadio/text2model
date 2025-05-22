% Parameters
int: D;
int: P;

set of int: DEPOTS = 1..D;
set of int: PORTS = 1..P;

array[DEPOTS] of int: Numdepot;         % containers available at each depot (supply)
array[PORTS]  of int: Numport;          % containers required at each port   (demand)

float: Price;                           % cost per unit distance per barge
array[DEPOTS, PORTS] of float: Distance; % distance matrix between depots and ports

% Derived parameter: an upper bound for barges on any arc
int: maxSupply = max(Numdepot);

% Variables
array[DEPOTS, PORTS] of var 0..maxSupply: barges;  % barges sent from depot d to port p
                                                   % (each barge carries exactly 2 containers)

% Constraints
constraint
  % Each depot can dispatch exactly the containers it has (in multiples of 2)
  forall(d in DEPOTS) (
    2 * sum(p in PORTS)(barges[d,p]) == Numdepot[d]
  );

constraint
  % Each port must receive exactly its requirement (in multiples of 2)
  forall(p in PORTS) (
    2 * sum(d in DEPOTS)(barges[d,p]) == Numport[p]
  );

% Objective
var float: totalCost =
    Price * sum(d in DEPOTS, p in PORTS) (Distance[d,p] * barges[d,p]);

solve minimize totalCost;