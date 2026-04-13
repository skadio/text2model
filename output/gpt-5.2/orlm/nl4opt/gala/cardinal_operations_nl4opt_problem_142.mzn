% Art store production planning (maximize profit)
include "globals.mzn";

% Data (embedded as required)
int: paint_avail   = 100;
int: glitter_avail = 50;
int: glue_avail    = 70;

int: paint_L   = 4;
int: glitter_L = 3;
int: glue_L    = 5;

int: paint_S   = 2;
int: glitter_S = 1;
int: glue_S    = 2;

int: min_L = 5;
int: min_S = 5;

int: profit_L = 30;
int: profit_S = 15;

% Decision variables: number of large and small pieces
% Upper bounds are safely limited by resources.
var min_L..(paint_avail div paint_L):   L;  % large pieces
var min_S..(paint_avail div paint_S):   S;  % small pieces

% Resource constraints
constraint paint_L   * L + paint_S   * S <= paint_avail;
constraint glitter_L * L + glitter_S * S <= glitter_avail;
constraint glue_L    * L + glue_S    * S <= glue_avail;

% Objective: maximize profit
var int: profit = profit_L * L + profit_S * S;

solve maximize profit;

output [
  "Large pieces (L) = ", show(L), "\n",
  "Small pieces (S) = ", show(S), "\n",
  "Max profit       = $", show(profit), "\n",
  "Paint used       = ", show(paint_L*L + paint_S*S), " / ", show(paint_avail), "\n",
  "Glitter used     = ", show(glitter_L*L + glitter_S*S), " / ", show(glitter_avail), "\n",
  "Glue used        = ", show(glue_L*L + glue_S*S), " / ", show(glue_avail), "\n"
];