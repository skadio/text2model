% Parameters
int: N;                                                % Number of translators
int: M;                                                % Number of required languages

array [1..N] of int: Cost;                             % Cost of each translator
array [1..N, 1..M] of 0..1: TranslatorLanguagesMatrix; % 1 if translator i covers language j
array [1..M] of string: RequiredLanguages;             % Names of the required languages

set of int: Translators = 1..N;
set of int: Languages   = 1..M;

% Variables
array [Translators] of var 0..1: SelectedTranslators;  % 1 if translator i is selected

% Constraints
constraint
  forall (j in Languages) (
    sum (i in Translators) (SelectedTranslators[i] * TranslatorLanguagesMatrix[i,j]) >= 1
  );

% Objective
solve minimize sum (i in Translators) (SelectedTranslators[i] * Cost[i]);