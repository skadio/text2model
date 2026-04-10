% Parameters
int: m;                         % Number of marks on the Golomb ruler
set of int: MARKS = 1..m;       % Index set for marks

int: nDiffs = m * (m - 1) div 2; % Number of pairwise differences
set of int: DIFFS = 1..nDiffs;   % Index set for differences


% Variables
array[MARKS] of var int: a;     % Positions of marks (strictly increasing, with a[1]=0)
array[DIFFS] of var int: d;     % Differences a[j]-a[i], all distinct and >= 1

var int: L;                     % Length of the ruler (equals a[m])


% Constraints
% Bound-related constraints (kept separate, as requested)
constraint a[1] = 0;
constraint L = a[m];
constraint forall(i in MARKS) (a[i] >= 0);
constraint forall(k in DIFFS) (d[k] >= 1);

% 1) Mark positions are strictly increasing (ensures positive differences)
constraint strictly_increasing(a);

% 2) Channel all pairwise differences into d in a fixed (i,j) enumeration
%    Map each pair (i,j) with 1 <= i < j <= m to a unique index k in 1..nDiffs.
constraint
  forall(i in 1..m-1, j in i+1..m) (
    let {
      int: k = (i - 1) * m - (i * (i + 1)) div 2 + (j - i)
    } in
      d[k] = a[j] - a[i]
  );

% 3) All differences must be distinct (Golomb property)
constraint all_different(d);

% 4) Symmetry breaking: first gap smaller than last gap
constraint a[2] - a[1] < a[m] - a[m-1];


% Objective
solve minimize L;