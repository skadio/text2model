int: N;  % Number of east-west streets
int: W;  % Number of north-south streets
array[1..N, 1..W-1] of float: WestTime;  % Time to cross street segment going west
array[1..N-1, 1..W] of float: NorthTime;  % Time to cross street segment going north

% Variables to represent the path taken
array[1..(N-1 + W-1)] of var 0..1: path;  % 0 = move west, 1 = move north

% Constraints to ensure the path is valid
constraint sum(i in 1..(N-1 + W-1))(path[i]) = (N-1);  % Must move north (N-1) times
constraint sum(i in 1..(N-1 + W-1))(1 - path[i]) = (W-1);  % Must move west (W-1) times

% Calculate the total time based on the path taken
var float: totalTime = sum(i in 1..(N-1 + W-1)(
    if path[i] = 0 then  % Move west
        if i <= W-1 then WestTime[1, i] else 0 endif
    else  % Move north
        if i <= N-1 then NorthTime[i, 1] else 0 endif
    endif
));

% Objective: Minimize the total time
solve minimize totalTime;

% Output the total time and the path taken
output [ "Total Time = ", show(totalTime), "\nPath = ", show(path), "\n" ];