% Parameters
int: N; % Number of translators
array[1..N] of int: Cost; % Cost of translator i
int: M; % Number of required languages
array[1..N, 1..M] of 0..1: TranslatorLanguagesMatrix; % Set of languages that translator i can translate

% Variables
array[1..N] of var 0..1: Translators; % Binary decision variable indicating whether a translator is selected or not

% Constraints
% Each required language must be covered by at least one selected translator
constraint forall(j in 1..M)(
  sum(i in 1..N)(Translators[i] * TranslatorLanguagesMatrix[i,j]) >= 1
);

% Objective
% Minimize the total cost of selected translators
solve minimize sum(i in 1..N)(Translators[i] * Cost[i]);