include "globals.mzn";

% Parameters
int: N; % Number of east-west streets
int: W; % Number of north-south streets
array[1..N, 1..W-1] of float: WestTime; % Time to cross street segment going west
array[1..N-1, 1..W] of float: NorthTime; % Time to cross street segment going north

% Variables
array[1..N, 1..W] of var float: Time; % Time to reach each intersection

% Constraints
constraint forall(i in 1..N, j in 1..W) (
    if i = 1 /\ j = 1 then
        Time[i,j] = 0
    elseif i = 1 then
        Time[i,j] = Time[i,j-1] + WestTime[i,j-1]
    elseif j = 1 then
        Time[i,j] = Time[i-1,j] + NorthTime[i-1,j]
    else
        Time[i,j] = min(Time[i-1,j] + NorthTime[i-1,j], Time[i,j-1] + WestTime[i,j-1])
    endif
);

% Objective
var float: TotalTime = Time[N,W];
solve minimize TotalTime;

% Output
output ["Total Time: ", show(TotalTime), "\n"];