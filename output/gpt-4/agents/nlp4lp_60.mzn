% Parameters
int: N; % Number of east-west streets
int: W; % Number of north-south streets
array[1..N, 1..W-1] of int: WestTime; % Time to cross street segment going west, for given street n and segment w
array[1..N-1, 1..W] of int: NorthTime; % Time to cross street segment going north, for given street n and segment w

% Variables
% The optimal time to reach each intersection, for given street n and avenue w
array[1..N, 1..W] of var int: OptimalTime;

% Constraints

% The delivery person starts at the intersection of 1st Avenue and 1st Street
constraint OptimalTime[1,1] = 0;

% For the first street, the only way to reach any avenue is by going west
constraint forall(w in 2..W) (
  OptimalTime[1,w] = OptimalTime[1,w-1] + WestTime[1,w-1]
);

% For the first avenue, the only way to reach any street is by going north
constraint forall(n in 2..N) (
  OptimalTime[n,1] = OptimalTime[n-1,1] + NorthTime[n-1,1]
);

% For the rest of the intersections, the optimal time is the minimum time to reach the intersection from the east or from the south
constraint forall(n in 2..N, w in 2..W) (
  OptimalTime[n,w] = min(OptimalTime[n-1,w] + NorthTime[n-1,w], OptimalTime[n,w-1] + WestTime[n,w-1])
);

% Objective
solve minimize OptimalTime[N,W];