% Parameters
int: N; % number of east-west streets
int: W; % number of north-south avenues

array[1..N, 1..W-1] of float: WestTime;   % time to go west along street n from avenue w to w+1
array[1..N-1, 1..W] of float: NorthTime;  % time to go north along avenue w from street n to n+1

% Variables
array[1..N, 1..W] of var bool: x;          % x[n,w] = 1 if intersection (n,w) is on the path
array[1..N, 1..W-1] of var bool: yW;       % yW[n,w] = 1 if move west from (n,w+1) to (n,w)
array[1..N-1, 1..W] of var bool: yN;       % yN[n,w] = 1 if move north from (n,w) to (n+1,w)

var float: TotalTime;

% Constraints
constraint N >= 1 /\ W >= 1;

% Start and end intersections must be used
constraint x[1,1] = true;
constraint x[N,W] = true;

% Path must be monotone: selected intersections form a "down-left closed" set
constraint forall(n in 2..N, w in 1..W) ( x[n,w] -> x[n-1,w] );
constraint forall(n in 1..N, w in 2..W) ( x[n,w] -> x[n,w-1] );

% Define west edges: boundary between used/not-used across adjacent avenues
constraint forall(n in 1..N, w in 1..W-1) (
  yW[n,w] <-> (x[n,w+1] /\ not x[n,w])
);

% Define north edges: boundary between used/not-used across adjacent streets
constraint forall(n in 1..N-1, w in 1..W) (
  yN[n,w] <-> (x[n,w] /\ not x[n+1,w])
);

% Ensure correct number of steps (exactly W-1 west moves and N-1 north moves)
constraint sum(n in 1..N, w in 1..W-1)(bool2int(yW[n,w])) = W - 1;
constraint sum(n in 1..N-1, w in 1..W)(bool2int(yN[n,w])) = N - 1;

% Total time
constraint TotalTime =
    sum(n in 1..N,   w in 1..W-1)( (if yW[n,w] then WestTime[n,w] else 0.0 endif) )
  + sum(n in 1..N-1, w in 1..W  )( (if yN[n,w] then NorthTime[n,w] else 0.0 endif) );

% Objective
solve minimize TotalTime;