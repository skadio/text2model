include "globals.mzn";

% Parameters
int: S;                 % slots per template
int: t;                 % number of templates
int: n;                 % number of design variations
array[1..n] of int: d;  % demand for each variation (nonnegative)

% Basic checks
constraint S > 0 /\ t > 0 /\ n > 0;
constraint forall(i in 1..n)(d[i] >= 0);

% Upper bound on number of sheets needed:
% In the worst case, a variation could appear in only 1 slot across all templates,
% so need at most max(d) sheets to meet any single demand.
int: XMAX = if max(d) = 0 then 0 else max(d) endif;

% Variables
array[1..t, 1..S] of var 1..n: slot;       % variation assigned to each slot
array[1..t, 1..n] of var 0..S: c;          % count of each variation on each template
array[1..t] of var 0..XMAX: x;             % number of mother sheets printed with each template
array[1..n] of var 0..(S * t * XMAX): prod;
array[1..n] of var 0..(S * t * XMAX): surplus;

% Link slot assignments to per-template variation counts
constraint
  forall(k in 1..t, i in 1..n)(
    c[k,i] = sum(s in 1..S)(bool2int(slot[k,s] = i))
  );

% Each template uses exactly S slots
constraint
  forall(k in 1..t)(
    sum(i in 1..n)(c[k,i]) = S
  );

% Production totals
constraint
  forall(i in 1..n)(
    prod[i] = sum(k in 1..t)(x[k] * c[k,i])
  );

% Meet demands and define surplus
constraint forall(i in 1..n)(prod[i] >= d[i]);
constraint forall(i in 1..n)(surplus[i] = prod[i] - d[i]);

% Lexicographic order of templates by slot sequence
constraint
  forall(k in 1..t-1)(
    lex_lesseq([slot[k,s] | s in 1..S], [slot[k+1,s] | s in 1..S])
  );

solve minimize sum(i in 1..n)(surplus[i]);