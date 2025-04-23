% Parameters
int: N; % Number of east-west streets
int: W; % Number of north-south streets
array[1..N, 1..W-1] of int: WestTime; % Time to cross street segment going west, for given street n and segment w
array[1..N-1, 1..W] of int: NorthTime; % Time to cross street segment going north, for given street n and segment w

% Variables
% The optimal time to reach each intersection, for given street n and avenue w
array[1..N, 1..W] of var int: OptimalTime;

% Constraints

% The optimal time to reach the starting intersection is 0
constraint OptimalTime[1,1] = 0;

% The optimal time to reach any intersection on the 1st Avenue is the sum of the times to cross the street segments going west
constraint forall(n in 2..N) (
  OptimalTime[n,1] = OptimalTime[n-1,1] + WestTime[n-1,1]
);

% The optimal time to reach any intersection on the 1st Street is the sum of the times to cross the street segments going north
constraint forall(w in 2..W) (
  OptimalTime[1,w] = OptimalTime[1,w-1] + NorthTime[1,w-1]
);

% The optimal time to reach any other intersection is the minimum of the time to reach the intersection to the east plus the time to cross the street segment going west, 
% and the time to reach the intersection to the south plus the time to cross the street segment going north
constraint forall(n in 2..N, w in 2..W) (
  OptimalTime[n,w] = min(OptimalTime[n-1,w] + WestTime[n-1,w], OptimalTime[n,w-1] + NorthTime[n,w-1])
);

% Objective
solve minimize OptimalTime[N,W];