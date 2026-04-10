int: S;
int: t;
int: n;
array[1..n] of int: d;

set of int: SLOT = 1..S;
set of int: TPL = 1..t;
set of int: VAR = 1..n;

% slot assignment for each template: which variation is etched in each slot
array[TPL, SLOT] of var VAR: slotVar;

% number of slots of each variation on each template
array[TPL, VAR] of var 0..S: slotsCount;

constraint
  forall(tp in TPL, v in VAR) (
    slotsCount[tp, v] = sum(s in SLOT)(bool2int(slotVar[tp, s] = v))
  );

% Lexicographic ordering of templates (row-wise), to avoid symmetric solutions
constraint
  forall(tp in 1..t-1) (
    lex_lesseq([slotVar[tp, s] | s in SLOT], [slotVar[tp+1, s] | s in SLOT])
  );

% copies printed from each template (nonnegative integer)
int: maxD = max(d);
array[TPL] of var 0..maxD: x;

% total produced for each variation
array[VAR] of var 0..(S*maxD*t): produced;
constraint
  forall(v in VAR) (
    produced[v] = sum(tp in TPL)(x[tp] * slotsCount[tp, v])
  );

% meet demand
constraint forall(v in VAR)(produced[v] >= d[v]);

% surplus to minimize
var 0..(S*maxD*t): surplus;
constraint surplus = sum(v in VAR)(produced[v] - d[v]);

solve minimize surplus;

output [
  "surplus = ", show(surplus), "\n",
  "x = ", show([x[tp] | tp in TPL]), "\n",
  "slotVar (templates x slots):\n",
  concat([ concat([ if s=1 then "" else " " endif ++ show(slotVar[tp,s]) | s in SLOT]) ++ "\n"
          | tp in TPL ]),
  "produced = ", show([produced[v] | v in VAR]), "\n"
];