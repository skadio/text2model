% Parameters
int: N; % Number of east-west streets
int: W; % Number of north-south streets
array[1..N, 1..W-1] of float: WestTime; % Time to cross street segment going west, for given street n and segment w
array[1..N-1, 1..W] of float: NorthTime; % Time to cross street segment going north, for given street n and segment w

% Variables
array[1..N, 1..W] of var float: Time; % Time taken to reach each intersection

% Constraints
% The time to reach the first intersection is 0
constraint Time[1,1] = 0;

% The time to reach any intersection on the 1st Avenue is the sum of the times to cross the previous street segments going west
constraint forall(n in 2..N) (
    Time[n,1] = Time[n-1,1] + WestTime[n-1,1]
);

% The time to reach any intersection on the 1st Street is the sum of the times to cross the previous street segments going north
constraint forall(w in 2..W) (
    Time[1,w] = Time[1,w-1] + NorthTime[1,w-1]
);

% The time to reach any other intersection is the minimum of the time to reach the intersection to the south plus the time to cross the street segment going north, and the time to reach the intersection to the east plus the time to cross the street segment going west
constraint forall(n in 2..N, w in 2..W) (
    Time[n,w] = min(Time[n-1,w] + WestTime[n-1,w], Time[n,w-1] + NorthTime[n,w-1])
);

% Objective
% The objective is to minimize the time to reach the intersection of W th Avenue and N th Street
solve minimize Time[N,W];