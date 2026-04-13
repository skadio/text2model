% Parameters
int: n;
array[1..n, 1..n] of int: puzzle; % use -1 for unknown ('X'), 0..9 for clues

% Variables
array[1..n, 1..n] of var 0..1: paint;

% Constraints
constraint
  forall(i in 1..n, j in 1..n) (
    (puzzle[i,j] >= 0) ->
      let {
        int: r1 = if i > 1 then i-1 else 1 endif,
        int: r2 = if i < n then i+1 else n endif,
        int: c1 = if j > 1 then j-1 else 1 endif,
        int: c2 = if j < n then j+1 else n endif
      } in
        sum(r in r1..r2, c in c1..c2)(paint[r,c]) = puzzle[i,j]
  );

% Objective
solve satisfy;