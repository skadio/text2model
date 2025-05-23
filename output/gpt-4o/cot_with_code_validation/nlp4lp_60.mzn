int: N;
int: W;

set of int: Streets  = 1..N;        % east-west streets (row index)
set of int: Avenues  = 1..W;        % north-south avenues (column index)
set of int: WestSegs = 1..W-1;      % segments between successive avenues
set of int: NorthSegs = 1..N-1;     % segments between successive streets

array[Streets, WestSegs]  of float: WestTime;   % time to move west
array[NorthSegs, Avenues] of float: NorthTime;  % time to move north

array[Streets, WestSegs]  of var 0..1: WestUsed;   % 1 if segment taken
array[NorthSegs, Avenues] of var 0..1: NorthUsed;  % 1 if segment taken

% Flow-balance at every intersection
constraint
  forall(n in Streets, w in Avenues) (
        ( (if w <= W-1 then WestUsed[n,w]  else 0 endif)
        + (if n <= N-1 then NorthUsed[n,w] else 0 endif) )
      - ( (if w > 1 then WestUsed[n,w-1]   else 0 endif)
        + (if n > 1 then NorthUsed[n-1,w]  else 0 endif) )
      =
        ( if n == 1 /\ w == 1 then  1
          elseif n == N /\ w == W then -1
          else 0 endif )
  );

% Exactly W-1 west moves and N-1 north moves
constraint sum(n in Streets,  w in WestSegs)(WestUsed[n,w])  = W - 1;
constraint sum(n in NorthSegs, w in Avenues)(NorthUsed[n,w]) = N - 1;

% Objective: minimise total travel time
var float: totalTime =
      sum(n in Streets,  w in WestSegs)( WestTime[n,w]  * float(WestUsed[n,w]) )
    + sum(n in NorthSegs, w in Avenues)( NorthTime[n,w] * float(NorthUsed[n,w]) );

solve minimize totalTime;