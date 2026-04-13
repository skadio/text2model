% Paper roll cutting to minimize waste area (embedded data)

% ----------------------
% Data
% ----------------------
int: nOrders = 3;
set of int: ORDERS = 1..nOrders;

% Scale widths to integers (mm) to avoid floating point issues
int: SCALE = 1000;

array[ORDERS] of int: orderWidthScaled  = [500, 700, 900]; % (mm)
array[ORDERS] of int: orderLength       = [1000, 3000, 2000]; % (m)

int: nMaster = 2;
set of int: MASTER = 1..nMaster;
array[MASTER] of int: masterWidthScaled = [1000, 2000]; % (mm)

% Maximum number of strips of each order that can fit across each master roll
array[MASTER, ORDERS] of int: maxStrips =
  array2d(MASTER, ORDERS,
    [
      % m=1 (1.0m): for o=1..3
      2, 1, 1,
      % m=2 (2.0m): for o=1..3
      4, 2, 2
    ]
  );

% ----------------------
% Decision variables
% ----------------------
% Choose one cutting pattern for each master width (strip counts across the width)
array[MASTER, ORDERS] of var 0..4: strips;
array[MASTER] of var 0..2000: wasteWidthScaled; % (mm)

% ----------------------
% Constraints
% ----------------------
constraint
  forall(m in MASTER, o in ORDERS) (
    strips[m,o] <= maxStrips[m,o]
  );

constraint
  forall(m in MASTER) (
    wasteWidthScaled[m] =
      masterWidthScaled[m] - sum(o in ORDERS)(strips[m,o] * orderWidthScaled[o])
  );

constraint
  forall(m in MASTER) (
    wasteWidthScaled[m] >= 0
  );

% Avoid degenerate "no cut" pattern
constraint
  forall(m in MASTER) (
    sum(o in ORDERS)(strips[m,o]) >= 1
  );

% ----------------------
% Objective
% ----------------------
% Minimize wasted width across the two master-width patterns (proxy for waste area per unit length)
solve minimize sum(m in MASTER)(wasteWidthScaled[m]);