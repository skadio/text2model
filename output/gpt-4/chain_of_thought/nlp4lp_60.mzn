% Parameters
int: N; % Number of east-west streets
int: W; % Number of north-south streets
array[1..N, 1..W-1] of float: WestTime; % Time to cross street segment going west
array[1..N-1, 1..W] of float: NorthTime; % Time to cross street segment going north

% Variables
array[1..N, 1..W] of var float: Time; % Time taken to reach each intersection

% Constraints
% Initial conditions
constraint Time[1,1] = 0;

% Boundary conditions
constraint forall(n in 2..N) (Time[n,1] = Time[n-1,1] + NorthTime[n-1,1]);
constraint forall(w in 2..W) (Time[1,w] = Time[1,w-1] + WestTime[1,w-1]);

% Recurrence relation for the rest of the grid
constraint forall(n in 2..N, w in 2..W) (
    Time[n,w] = min(Time[n-1,w] + NorthTime[n-1,w], Time[n,w-1] + WestTime[n,w-1])
);

% Objective
solve minimize Time[N,W];