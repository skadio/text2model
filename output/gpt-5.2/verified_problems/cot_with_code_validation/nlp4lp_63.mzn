% Team of translators: minimum cost set cover

% Parameters
int: N;
array[1..N] of int: Cost;

int: M;
array[1..M] of string: RequiredLanguages;

array[1..N, 1..M] of 0..1: TranslatorLanguagesMatrix; % binary (0/1)

% Decision variables
array[1..N] of var 0..1: x; % 1 if translator i is selected

% Constraints: every required language must be covered by at least one selected translator
constraint
  forall(j in 1..M) (
    sum(i in 1..N)(x[i] * TranslatorLanguagesMatrix[i,j]) >= 1
  );

% Objective: minimize total cost
solve minimize sum(i in 1..N)(Cost[i] * x[i]);

output [
  "total_cost=", show(sum(i in 1..N)(Cost[i] * x[i])), "\n",
  "selected_translators=", show([i | i in 1..N where fix(x[i]) = 1]), "\n"
];