% Parameters
int: N;                                   % Number of translators
array[1..N] of int: Cost;                 % Cost of translator i

int: M;                                   % Number of required languages
array[1..M] of string: RequiredLanguages; % Names/codes of required languages (reference/reporting only)

array[1..N, 1..M] of int: TranslatorLanguagesMatrix;
% Binary matrix: 1 if translator i can translate into required language j, else 0

% Variables
array[1..N] of var 0..1: selectTranslator; % 1 if translator i is selected, else 0
var 0..sum(Cost): totalCost;               % Total cost of selected translators

% Constraints
% Link totalCost to the sum of costs of selected translators
constraint
  totalCost = sum(i in 1..N)(Cost[i] * selectTranslator[i]);

% Coverage constraints: each required language must be covered by at least one selected translator
constraint
  forall(j in 1..M) (
    sum(i in 1..N)(TranslatorLanguagesMatrix[i, j] * selectTranslator[i]) >= 1
  );

% Objective
solve minimize totalCost;