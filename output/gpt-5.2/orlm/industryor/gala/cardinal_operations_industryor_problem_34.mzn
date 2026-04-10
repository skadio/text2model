include "globals.mzn";

% -----------------------
% Data (embedded)
% -----------------------
int: nBatches = 5;
int: nVats = 3;

% Scale by 10 to avoid fractions (e.g., 1.5h -> 15)
array[1..nBatches, 1..nVats] of int: dur =
  [| 30, 10, 10
   | 20, 15, 10
   | 30, 12, 13
   | 20, 20, 20
   | 21, 20, 30 |];

% Makespan upper bound (sum of all processing times on all vats)
int: H = sum(b in 1..nBatches, v in 1..nVats)(dur[b,v]);

% -----------------------
% Decision variables
% -----------------------
array[1..nBatches, 1..nVats] of var 0..H: start;
array[1..nBatches, 1..nVats] of var 0..H: finish;

% -----------------------
% Constraints
% -----------------------
constraint forall(b in 1..nBatches, v in 1..nVats)(
  finish[b,v] = start[b,v] + dur[b,v]
);

% Flow-shop precedence: each batch must go through vats 1 -> 2 -> 3 in order
constraint forall(b in 1..nBatches, v in 1..nVats-1)(
  start[b,v+1] >= finish[b,v]
);

% Each vat is a unary resource (capacity 1): no overlap on the same vat
constraint
  forall(v in 1..nVats)(
    cumulative([ start[b,v] | b in 1..nBatches ],
               [ dur[b,v]   | b in 1..nBatches ],
               [ 1          | b in 1..nBatches ],
               1)
  );

% Makespan (completion time of the last batch on vat 3)
var 0..H: makespan;
constraint makespan = max([ finish[b,nVats] | b in 1..nBatches ]);

% -----------------------
% Solve
% -----------------------
solve minimize makespan;

% -----------------------
% Output
% -----------------------
output
[
  "Makespan (scaled by 10) = ", show(makespan), "\n",
  "Makespan (hours) = ", show(makespan div 10), ".", show(makespan mod 10), "\n\n",
  "Start times (scaled by 10):\n",
  concat([ "Batch " ++ show(b) ++ ": " ++ show([ start[b,v] | v in 1..nVats ]) ++ "\n"
         | b in 1..nBatches ]),
  "\nFinish times (scaled by 10):\n",
  concat([ "Batch " ++ show(b) ++ ": " ++ show([ finish[b,v] | v in 1..nVats ]) ++ "\n"
         | b in 1..nBatches ])
];