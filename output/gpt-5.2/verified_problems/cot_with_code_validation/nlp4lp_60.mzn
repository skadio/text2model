% Parameters
int: N; % number of east-west streets
int: W; % number of north-south avenues

array[1..N, 1..W-1] of float: WestTime;   % time to go west from (n,w) to (n,w+1)
array[1..N-1, 1..W] of float: NorthTime;  % time to go north from (n,w) to (n+1,w)

% Variables: x[n,w] = true iff intersection (n,w) is on the chosen path
array[1..N, 1..W] of var bool: x;

var float: total_time;

% Constraints
constraint x[1,1] = true;
constraint x[N,W] = true;

% Exactly one move leaves start, one move enters end
constraint bool2int(x[1,2]) + bool2int(x[2,1]) = 1;
constraint bool2int(x[N,W-1]) + bool2int(x[N-1,W]) = 1;

% Border constraints (excluding endpoints handled above)
constraint forall(n in 2..N-1) ( x[n,1] -> x[n-1,1] );
constraint forall(w in 2..W-1) ( x[1,w] -> x[1,w-1] );
constraint forall(n in 2..N-1) ( x[n,W] -> x[n-1,W] );
constraint forall(w in 2..W-1) ( x[N,w] -> x[N,w-1] );

% Interior flow: any used interior node has exactly one predecessor and one successor
constraint forall(n in 2..N-1, w in 2..W-1) (
  x[n,w] ->
    (bool2int(x[n-1,w]) + bool2int(x[n,w-1]) = 1) /\
    (bool2int(x[n+1,w]) + bool2int(x[n,w+1]) = 1)
);

% Prevent branching (redundant but safe)
constraint forall(n in 2..N-1, w in 2..W-1) (
  (bool2int(x[n-1,w]) + bool2int(x[n,w-1]) <= 1) /\
  (bool2int(x[n+1,w]) + bool2int(x[n,w+1]) <= 1)
);

% Total time is sum of times for each traversed edge
constraint
  total_time =
    sum(n in 1..N, w in 1..W-1) ( bool2int(x[n,w] /\ x[n,w+1]) * WestTime[n,w] )
  + sum(n in 1..N-1, w in 1..W) ( bool2int(x[n,w] /\ x[n+1,w]) * NorthTime[n,w] );

solve minimize total_time;