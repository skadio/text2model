% Parameters
int: N; % Number of translators
array[1..N] of int: Cost; % Cost of each translator
int: M; % Number of required languages
array[1..M] of int: RequiredLanguages; % List of required languages
array[1..N, 1..M] of 0..1: TranslatorLanguagesMatrix; % Binary matrix indicating which languages each translator can translate

% Variables
array[1..N] of var 0..1: TranslatorSelection; % Binary decision variable indicating whether each translator is selected

% Constraints

% Ensure all required languages are covered by the selected translators
constraint forall(i in 1..M)(
    sum(j in 1..N)(TranslatorSelection[j] * TranslatorLanguagesMatrix[j, RequiredLanguages[i]]) >= 1
);

% Ensure that if a translator is selected, the cost is accounted for
constraint sum(i in 1..N)(TranslatorSelection[i] * Cost[i]) >= 0;

% Objective
solve minimize sum(i in 1..N)(TranslatorSelection[i] * Cost[i]);