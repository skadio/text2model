% Parameters
% Sets / indices
int: nProducts = 3;
set of int: PRODUCTS = 1..nProducts;        % 1=I, 2=II, 3=III

int: nAEquip = 2;
set of int: AEQUIP = 1..nAEquip;            % 1=A1, 2=A2

int: nBEquip = 3;
set of int: BEQUIP = 1..nBEquip;            % 1=B1, 2=B2, 3=B3

% Processing time per piece (minutes); 0 means "not allowed / not available"
array[AEQUIP, PRODUCTS] of int: timeA =
[
  % I  II III
  | 5, 10,  0   % A1
  | 7,  9, 12   % A2
];

array[BEQUIP, PRODUCTS] of int: timeB =
[
  % I  II III
  | 6,  8,  0   % B1
  | 4,  0, 11   % B2
  | 7,  0,  0   % B3
];

% Effective machine hours available (hours)
array[AEQUIP] of int: availHoursA = [6000, 10000];      % A1, A2
array[BEQUIP] of int: availHoursB = [4000, 7000, 4000]; % B1, B2, B3

% Processing cost per machine hour (Yuan/hour)
array[AEQUIP] of float: costPerHourA = [0.05, 0.03];
array[BEQUIP] of float: costPerHourB = [0.06, 0.11, 0.05];

% Raw material cost per piece (Yuan/piece)
array[PRODUCTS] of float: rawCost = [0.25, 0.35, 0.5];

% Sales unit price per piece (Yuan/piece)
array[PRODUCTS] of float: unitPrice = [1.25, 2.0, 2.8];

% Constants / conversions
int: minutesPerHour = 60;

% Convenience: max possible units bounded by capacity (very loose but finite)
int: maxUnitsUpperBound =
  max(
    [ (max(availHoursA) * minutesPerHour) div 1,
      (max(availHoursB) * minutesPerHour) div 1 ]
  );

% Variables
% Units of each product processed on each machine type (integer pieces)
array[AEQUIP, PRODUCTS] of var 0..maxUnitsUpperBound: xA;  % pieces of product p on A equipment a
array[BEQUIP, PRODUCTS] of var 0..maxUnitsUpperBound: xB;  % pieces of product p on B equipment b

% Total production quantity per product (pieces)
array[PRODUCTS] of var 0..maxUnitsUpperBound: q;

% Total profit (Yuan)
var float: profit;


% Constraints

% ---- Bounding/feasibility constraints for "not allowed" routes (time=0) ----
constraint
  forall(a in AEQUIP, p in PRODUCTS where timeA[a,p] = 0) ( xA[a,p] = 0 ) /\
  forall(b in BEQUIP, p in PRODUCTS where timeB[b,p] = 0) ( xB[b,p] = 0 );

% ---- Flow consistency: stage A and stage B quantities must match product totals ----
constraint forall(p in PRODUCTS) (
  q[p] = sum(a in AEQUIP)(xA[a,p]) /\
  q[p] = sum(b in BEQUIP)(xB[b,p])
);

% ---- Capacity constraints (machine minutes used <= available minutes) ----
constraint forall(a in AEQUIP)(
  sum(p in PRODUCTS)( timeA[a,p] * xA[a,p] ) <= availHoursA[a] * minutesPerHour
);

constraint forall(b in BEQUIP)(
  sum(p in PRODUCTS)( timeB[b,p] * xB[b,p] ) <= availHoursB[b] * minutesPerHour
);

% ---- Profit definition (revenue - raw material - processing costs) ----
% Revenue and raw material cost depend on total finished quantity q[p].
% Processing costs are computed from machine minutes used converted to hours.
constraint
  profit =
    sum(p in PRODUCTS)(
      (unitPrice[p] - rawCost[p]) * int2float(q[p])
    )
    - sum(a in AEQUIP)(
        costPerHourA[a] *
        (sum(p in PRODUCTS)( int2float(timeA[a,p]) * int2float(xA[a,p]) ) / int2float(minutesPerHour))
      )
    - sum(b in BEQUIP)(
        costPerHourB[b] *
        (sum(p in PRODUCTS)( int2float(timeB[b,p]) * int2float(xB[b,p]) ) / int2float(minutesPerHour))
      );


% Objective
solve maximize profit;