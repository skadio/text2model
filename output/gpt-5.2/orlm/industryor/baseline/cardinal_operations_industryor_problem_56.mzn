% Paper roll cutting to satisfy width/length demands with minimal waste area.
% Stock widths: 1m and 2m. Stock length is unlimited and can be spliced,
% so decision is how many "lanes" of each order width are cut from each stock width.
% Each lane provides unlimited length; total length produced is sum(lanes)*stock_length.
% To meet demand lengths, we choose stock lengths produced on each pattern.
% Waste area = (stock_width - used_width)*stock_length for each produced pattern.

% ----- Data -----
int: N = 3;
set of int: ORD = 1..N;

array[ORD] of float: w = [0.5, 0.7, 0.9];     % order widths (m)
array[ORD] of float: Ldem = [1000.0, 3000.0, 2000.0]; % required lengths (m)

int: M = 2;
set of int: STOCK = 1..M;
array[STOCK] of float: W = [1.0, 2.0];        % stock widths (m)

% Lane upper bounds for each order and stock width
array[STOCK, ORD] of int: lane_ub =
  array2d(STOCK, ORD, [
    2, 1, 1,   % stock 1.0: floor(1/0.5)=2, floor(1/0.7)=1, floor(1/0.9)=1
    4, 2, 2    % stock 2.0: floor(2/0.5)=4, floor(2/0.7)=2, floor(2/0.9)=2
  ]);

% Maximum number of candidate patterns per stock width (enumerate all combinations)
array[STOCK] of int: Pmax = [ (lane_ub[1,1]+1)*(lane_ub[1,2]+1)*(lane_ub[1,3]+1),
                             (lane_ub[2,1]+1)*(lane_ub[2,2]+1)*(lane_ub[2,3]+1) ];

% Maximum length to consider producing on any one pattern (sum of demands is safe)
float: Lmax = sum(o in ORD)(Ldem[o]);

% ----- Helper: enumerate all patterns for each stock width -----
% We index patterns p = 1..Pmax[s] and decode into lane counts for each order.
function int: decode(int: idx, int: base, int: digit) =
  (idx div base) mod digit;

% pattern lanes: lanes[s,p,o] = number of lanes of order o cut from stock s in pattern p
array[STOCK] of int: b2 = [lane_ub[1,1]+1, lane_ub[2,1]+1];
array[STOCK] of int: b3 = [ (lane_ub[1,1]+1)*(lane_ub[1,2]+1),
                            (lane_ub[2,1]+1)*(lane_ub[2,2]+1) ];

array[STOCK, 1..max(Pmax), ORD] of int: lanes =
  array3d(STOCK, 1..max(Pmax), ORD,
    [ if s==1 then
        let {
          int: a1 = lane_ub[1,1]+1,
          int: a2 = lane_ub[1,2]+1,
          int: a3 = lane_ub[1,3]+1
        } in
        if p <= Pmax[1] then
          [ decode(p-1, 1, a1),
            decode(p-1, a1, a2),
            decode(p-1, a1*a2, a3) ]
        else [0,0,0] endif
      else
        let {
          int: a1 = lane_ub[2,1]+1,
          int: a2 = lane_ub[2,2]+1,
          int: a3 = lane_ub[2,3]+1
        } in
        if p <= Pmax[2] then
          [ decode(p-1, 1, a1),
            decode(p-1, a1, a2),
            decode(p-1, a1*a2, a3) ]
        else [0,0,0] endif
      endif
      | s in STOCK, p in 1..max(Pmax), o in ORD ]
  );

% used width for each pattern
array[STOCK, 1..max(Pmax)] of float: usedW =
  array2d(STOCK, 1..max(Pmax),
    [ if p <= Pmax[s] then sum(o in ORD)(w[o] * lanes[s,p,o]) else 0.0 endif
      | s in STOCK, p in 1..max(Pmax) ]);

% pattern validity: used width must not exceed stock width and must cut at least one lane
array[STOCK, 1..max(Pmax)] of bool: valid =
  array2d(STOCK, 1..max(Pmax),
    [ p <= Pmax[s] /\
      usedW[s,p] <= W[s] + 1e-9 /\
      sum(o in ORD)(lanes[s,p,o]) >= 1
      | s in STOCK, p in 1..max(Pmax) ]);

% ----- Decision variables -----
% Length produced on each pattern (continuous). 0 means pattern not used.
array[STOCK, 1..max(Pmax)] of var 0.0..Lmax: x;

% ----- Constraints -----
% Do not use invalid patterns
constraint forall(s in STOCK, p in 1..max(Pmax)) (
  (not valid[s,p]) -> (x[s,p] = 0.0)
);

% Meet (at least) each order length demand:
% Total length produced for order o = sum over patterns of (lanes)*x
constraint forall(o in ORD) (
  sum(s in STOCK, p in 1..max(Pmax))( lanes[s,p,o] * x[s,p] ) >= Ldem[o]
);

% ----- Objective: minimize waste area -----
% Waste area for pattern = (stock_width - used_width) * produced_length
var float: total_waste =
  sum(s in STOCK, p in 1..max(Pmax)) ( (W[s] - usedW[s,p]) * x[s,p] );

solve minimize total_waste;

% ----- Output: show chosen cutting patterns and lengths -----
output [
  "Minimum waste area (m^2): ", show(total_waste), "\n\n",
  "Cutting plan (only patterns with positive produced length shown):\n",
  concat([
    if fix(x[s,p]) > 1e-6 then
      "Stock width " ++ show(W[s]) ++ "m, produce length " ++ show(x[s,p]) ++ "m, lanes: " ++
      concat([ "order" ++ show(o) ++ "=" ++ show(lanes[s,p,o]) ++ (if o<N then ", " else "" endif)
             | o in ORD ]) ++
      " | used width=" ++ show(usedW[s,p]) ++ "m, waste strip=" ++ show(W[s]-usedW[s,p]) ++ "m\n"
    else "" endif
    | s in STOCK, p in 1..max(Pmax)
  ])
];