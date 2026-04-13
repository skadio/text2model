% Factory production planning (LP as integer; choose nonnegative integer pieces)
include "globals.mzn";

%----------------------------
% Data (embedded from table)
%----------------------------

set of int: P = 1..3; % 1=I, 2=II, 3=III

% Effective machine hours (hours available)
int: capA1 = 6000;
int: capA2 = 10000;
int: capB1 = 4000;
int: capB2 = 7000;
int: capB3 = 4000;

% Processing time per piece on each equipment (hours/piece); 0 means not allowed
array[P] of int: tA1 = [5, 10, 0];
array[P] of int: tA2 = [7, 9, 12];

array[P] of int: tB1 = [6, 8, 0];
array[P] of int: tB2 = [4, 0, 11];
array[P] of int: tB3 = [7, 0, 0];

% Costs (Yuan per machine hour)
float: cA1 = 0.05;
float: cA2 = 0.03;
float: cB1 = 0.06;
float: cB2 = 0.11;
float: cB3 = 0.05;

% Raw material cost (Yuan/piece)
array[P] of float: raw = [0.25, 0.35, 0.5];

% Sales price (Yuan/piece)
array[P] of float: price = [1.25, 2.0, 2.8];

% Scale money by 100 to use integer objective (cents)
int: SCALE = 100;

%----------------------------
% Decision variables
%----------------------------

% Pieces produced on each allowed machine (integer pieces)
array[P] of var 0..100000: xA1;
array[P] of var 0..100000: xA2;

array[P] of var 0..100000: xB1;
array[P] of var 0..100000: xB2;
array[P] of var 0..100000: xB3;

% Total pieces of each product
array[P] of var 0..100000: x;

%----------------------------
% Feasibility / routing constraints
%----------------------------

% Disallow impossible processing routes (times marked "-" in table)
constraint xA1[3] = 0;          % A1 cannot process III
constraint xB1[3] = 0;          % B1 cannot process III
constraint xB2[2] = 0;          % B2 cannot process II
constraint xB3[2] = 0 /\ xB3[3] = 0; % B3 cannot process II or III

% Flow balance: every produced piece must be processed once in stage A and once in stage B
constraint forall(p in P) (
  x[p] = xA1[p] + xA2[p]
);
constraint forall(p in P) (
  x[p] = xB1[p] + xB2[p] + xB3[p]
);

% Machine capacity constraints (sum of hours used <= effective hours)
constraint sum(p in P)(tA1[p] * xA1[p]) <= capA1;
constraint sum(p in P)(tA2[p] * xA2[p]) <= capA2;

constraint sum(p in P)(tB1[p] * xB1[p]) <= capB1;
constraint sum(p in P)(tB2[p] * xB2[p]) <= capB2;
constraint sum(p in P)(tB3[p] * xB3[p]) <= capB3;

%----------------------------
% Objective: maximize profit
% Profit = revenue - raw material - processing costs
%----------------------------

% Integer (scaled) profit expression
var int: profitCents =
  sum(p in P)(round(price[p] * SCALE) * x[p])
  - sum(p in P)(round(raw[p] * SCALE) * x[p])
  - ( round(cA1 * SCALE) * sum(p in P)(tA1[p] * xA1[p])
    + round(cA2 * SCALE) * sum(p in P)(tA2[p] * xA2[p])
    + round(cB1 * SCALE) * sum(p in P)(tB1[p] * xB1[p])
    + round(cB2 * SCALE) * sum(p in P)(tB2[p] * xB2[p])
    + round(cB3 * SCALE) * sum(p in P)(tB3[p] * xB3[p])
    );

solve maximize profitCents;

%----------------------------
% Output
%----------------------------
output [
  "Optimal profit (Yuan) = ", show(profitCents / float(SCALE)), "\n",
  "Pieces produced [I, II, III] = ", show(x), "\n",
  "Stage A allocation (A1) = ", show(xA1), "\n",
  "Stage A allocation (A2) = ", show(xA2), "\n",
  "Stage B allocation (B1) = ", show(xB1), "\n",
  "Stage B allocation (B2) = ", show(xB2), "\n",
  "Stage B allocation (B3) = ", show(xB3), "\n",
  "Hours used A1 = ", show(sum(p in P)(tA1[p] * xA1[p])), " / ", show(capA1), "\n",
  "Hours used A2 = ", show(sum(p in P)(tA2[p] * xA2[p])), " / ", show(capA2), "\n",
  "Hours used B1 = ", show(sum(p in P)(tB1[p] * xB1[p])), " / ", show(capB1), "\n",
  "Hours used B2 = ", show(sum(p in P)(tB2[p] * xB2[p])), " / ", show(capB2), "\n",
  "Hours used B3 = ", show(sum(p in P)(tB3[p] * xB3[p])), " / ", show(capB3), "\n"
];