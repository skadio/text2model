% Parameters
int: S;                 % slots per template
int: t;                 % number of templates
int: n;                 % number of design variations
array[1..n] of int: d;  % demand per variation

% Variables
array[1..t, 1..S] of var 1..n: slot;                % variation assigned to each slot
array[1..t, 1..n] of var 0..S: count_on_template;    % how many slots of each variation on template k
array[1..n] of var 0..S*t: produced;                % total produced (in slot-units)
array[1..n] of var 0..S*t: surplus;                 % produced - demand (nonnegative)

% Constraints
constraint
  forall(k in 1..t, i in 1..n)(
    count_on_template[k,i] = sum(s in 1..S)(bool2int(slot[k,s] == i))
  );

constraint
  forall(k in 1..t)(
    sum(i in 1..n)(count_on_template[k,i]) = S
  );

constraint
  forall(i in 1..n)(
    produced[i] = sum(k in 1..t)(count_on_template[k,i])
  );

constraint
  forall(i in 1..n)(
    produced[i] >= d[i]
  );

constraint
  forall(i in 1..n)(
    surplus[i] = produced[i] - d[i]
  );

% Lexicographic order of templates (compare slot sequences)
constraint
  forall(k in 1..t-1)(
    lex_lesseq([slot[k,s] | s in 1..S], [slot[k+1,s] | s in 1..S])
  );

% Objective
solve minimize sum(i in 1..n)(surplus[i]);