% Parameters
int: R = 1850;                 % raw pipe length (mm)
int: I = 4;                    % number of item types
set of int: ITEMS = 1..I;

array[ITEMS] of int: len = [290, 315, 350, 455];
array[ITEMS] of int: dem = [15, 28, 21, 30];

int: Kmax = 4;                 % max number of patterns
set of int: PATS = 1..Kmax;

int: maxPieces = 5;            % at most 5 pieces per raw pipe in any pattern
int: maxWaste = 100;           % leftover length <= 100 mm

% Ranking cost coefficients (in tenths of a pipe value)
array[1..Kmax] of int: rankCostTenths = [1,2,3,4];

% Upper bound on number of raw pipes needed (safe)
int: UBpipes = sum(i in ITEMS)(dem[i]);  % worst case: 1 piece per pipe

% Big-M for frequency comparisons
int: M = UBpipes;

% Variables
array[PATS, ITEMS] of var 0..maxPieces: a;     % pieces of item i produced by pattern p (per pipe)
array[PATS] of var 0..UBpipes: x;              % number of raw pipes cut with pattern p
array[PATS] of var 0..maxWaste: waste;         % leftover length in pattern p

array[PATS] of var bool: used;                 % whether pattern p is used (x[p] > 0)

% permutation: pos[p] = rank position of pattern p (1=most used, 4=least)
array[PATS] of var 1..Kmax: pos;

% pairwise order variables: ord[p,q]=1 if pattern p is used >= pattern q (ties allowed)
array[PATS, PATS] of var bool: ge;

% Total pipes
var 0..UBpipes: totalPipes = sum(p in PATS)(x[p]);

% Total cost in tenths of a pipe value:
% base cost = totalPipes*10, plus extra rank cost for each used pattern
var 0..(UBpipes*10 + Kmax*4): totalCostTenths;

% Constraints
% Link used with x
constraint forall(p in PATS)(
  used[p] <-> (x[p] > 0)
);

% Pattern feasibility: total pieces <= 5 and waste within 0..100
constraint forall(p in PATS)(
  sum(i in ITEMS)(a[p,i]) <= maxPieces
);

% Waste definition: R - produced length
constraint forall(p in PATS)(
  waste[p] = R - sum(i in ITEMS)(len[i] * a[p,i])
);

% Ensure nonnegative leftover and <= maxWaste already by var bound; also ensure not overcut
constraint forall(p in PATS)(
  sum(i in ITEMS)(len[i] * a[p,i]) <= R
);

% If pattern not used, make it the zero pattern to avoid symmetry/invalid ranks costing
constraint forall(p in PATS)(
  (not used[p]) -> forall(i in ITEMS)(a[p,i] = 0)
);

% Demand satisfaction: total produced across all pipes meets demand exactly
constraint forall(i in ITEMS)(
  sum(p in PATS)(x[p] * a[p,i]) = dem[i]
);

% Ranking / ordering logic based on x:
% ge[p,q] <-> x[p] >= x[q]
constraint forall(p in PATS, q in PATS where p != q)(
  (ge[p,q] -> x[p] - x[q] >= 0) /\
  ((not ge[p,q]) -> x[q] - x[p] >= 1)
);

% For p=q, enforce ge[p,p]=true
constraint forall(p in PATS)(ge[p,p] = true);

% pos[p] is 1 + number of patterns strictly greater than p
% Strictly greater than p means NOT ge[p,q] (i.e., x[q] >= x[p] + 1)
constraint forall(p in PATS)(
  pos[p] = 1 + sum(q in PATS where q != p)(bool2int(not ge[p,q]))
);

% Break ties deterministically by index to avoid multiple permutations with same x:
% if x[p]=x[q] and p<q then pos[p] <= pos[q]
constraint forall(p in PATS, q in PATS where p < q)(
  (x[p] = x[q]) -> (pos[p] <= pos[q])
);

% If a pattern is unused (x=0), push it to the end ranks preferentially:
constraint forall(p in PATS)(
  (not used[p]) -> (x[p] = 0)
);

% Total cost (tenths):
% base: 10 per pipe; extra: rankCostTenths[pos[p]] for each used pattern
constraint totalCostTenths =
  totalPipes * 10
  + sum(p in PATS)( bool2int(used[p]) * rankCostTenths[pos[p]] );

% Objective
solve minimize totalCostTenths;