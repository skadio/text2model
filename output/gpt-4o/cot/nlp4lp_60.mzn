% Parameters
int: N;
int: W;

array[1..N, 1..W-1] of float: WestTime;
array[1..N-1, 1..W] of float: NorthTime;

% Decision variables: whether a segment is used
array[1..N, 1..W-1] of var bool: west_use;
array[1..N-1, 1..W] of var bool: north_use;

% Total travel time
var float: total_time =
    sum(n in 1..N, w in 1..W-1)(
        int2float(bool2int(west_use[n,w])) * WestTime[n,w]
    )
  + sum(n in 1..N-1, w in 1..W)(
        int2float(bool2int(north_use[n,w])) * NorthTime[n,w]
    );

% Required number of moves in each direction
constraint
    sum(n in 1..N,   w in 1..W-1)( bool2int(west_use[n,w]) ) = W - 1 /\
    sum(n in 1..N-1, w in 1..W  )( bool2int(north_use[n,w]) ) = N - 1;

% Flow conservation at every intersection
constraint
    forall(n in 1..N, w in 1..W) (
        let {
            var int: flow_in =
                (if n > 1 then bool2int(north_use[n-1,w]) else 0 endif) +
                (if w > 1 then bool2int(west_use[n,w-1])  else 0 endif),
            var int: flow_out =
                (if n < N then bool2int(north_use[n,w])   else 0 endif) +
                (if w < W then bool2int(west_use[n,w])    else 0 endif)
        } in
            if n = 1 /\ w = 1 then
                flow_out - flow_in = 1
            elseif n = N /\ w = W then
                flow_in - flow_out = 1
            else
                flow_in = flow_out
            endif
    );

solve minimize total_time;