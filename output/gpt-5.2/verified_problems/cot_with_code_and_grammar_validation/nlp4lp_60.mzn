% Parameters
int: N;
int: W;

array[1..N, 1..W-1] of float: WestTime;
array[1..N-1, 1..W] of float: NorthTime;

% Variables
array[1..N, 1..W] of var bool: x; % x[n,w]=true if intersection (n,w) is on the chosen path

var float: TotalTime;

% Constraints
constraint x[1,1] = true;
constraint x[N,W] = true;

% Forbid visiting intersections outside the rectangle (already enforced by indices)

% Flow conservation / path structure:
% Each visited node (except start/end) has exactly one predecessor and one successor.
% Movement allowed only North (increase n) or West (increase w).
constraint
  forall(n in 1..N, w in 1..W) (
    let {
      var int: in_deg =
        (if n > 1 then bool2int(x[n-1,w]) else 0 endif) +
        (if w > 1 then bool2int(x[n,w-1]) else 0 endif),
      var int: out_deg =
        (if n < N then bool2int(x[n+1,w]) else 0 endif) +
        (if w < W then bool2int(x[n,w+1]) else 0 endif)
    } in
      if (n = 1 /\ w = 1) then
        in_deg = 0 /\ out_deg = 1
      elseif (n = N /\ w = W) then
        in_deg = 1 /\ out_deg = 0
      else
        (bool2int(x[n,w]) = 0 -> in_deg = 0 /\ out_deg = 0) /\
        (bool2int(x[n,w]) = 1 -> in_deg = 1 /\ out_deg = 1)
      endif
  );

% Objective time: sum of chosen directed edges
% North move: (n,w)->(n+1,w) costs NorthTime[n,w] for n=1..N-1
% West move : (n,w)->(n,w+1) costs WestTime[n,w] for w=1..W-1
constraint
  TotalTime =
    sum(n in 1..N-1, w in 1..W) ( NorthTime[n,w] * bool2float(x[n,w] /\ x[n+1,w]) ) +
    sum(n in 1..N, w in 1..W-1) ( WestTime[n,w]  * bool2float(x[n,w] /\ x[n,w+1]) );

% Objective
solve minimize TotalTime;