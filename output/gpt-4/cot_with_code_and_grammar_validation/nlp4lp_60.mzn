% Parameters
int: N; % Number of east-west streets
int: W; % Number of north-south streets
array[1..N, 1..W-1] of float: WestTime; % Time to cross street segment going west
array[1..N-1, 1..W] of float: NorthTime; % Time to cross street segment going north

% Variables
array[1..N, 1..W] of var float: Time; % Time taken to reach each intersection

% Constraints
% Time to reach the starting point is 0
constraint Time[1,1] = 0;

% Time to reach any point on the 1st Avenue is the sum of the times of the westward segments on that avenue
constraint forall(w in 2..W) (
    Time[1,w] = Time[1,w-1] + WestTime[1,w-1]
);

% Time to reach any point on the 1st Street is the sum of the times of the northward segments on that street
constraint forall(n in 2..N) (
    Time[n,1] = Time[n-1,1] + NorthTime[n-1,1]
);

% For all other intersections, the time to reach is the minimum of the time to reach the intersection to the west plus the time to cross the westward segment, and the time to reach the intersection to the north plus the time to cross the northward segment
constraint forall(n in 2..N, w in 2..W) (
    Time[n,w] = min(Time[n,w-1] + WestTime[n,w-1], Time[n-1,w] + NorthTime[n-1,w])
);

% Objective
% Minimize the time to reach the destination
solve minimize Time[N,W];