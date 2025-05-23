% Parameters
int: N; % Number of translators
array[1..N] of int: Cost; % Cost of each translator
int: M; % Number of required languages
array[1..M] of int: RequiredLanguages; % List of required languages
array[1..N, 1..M] of 0..1: TranslatorLanguagesMatrix; % Matrix indicating which translator can translate which language

% Variables
array[1..N] of var 0..1: TranslatorSelection; % Binary decision variable indicating whether a translator is selected or not

% Constraints

% Ensure all required languages can be translated
constraint forall(i in 1..M)(
    sum(j in 1..N)(TranslatorSelection[j] * TranslatorLanguagesMatrix[j, RequiredLanguages[i]]) >= 1
);

% Limit the selection of translators to those that can translate at least one required language
constraint forall(i in 1..N)(
    sum(j in 1..M)(TranslatorLanguagesMatrix[i, RequiredLanguages[j]]) >= TranslatorSelection[i]
);

% Objective
solve minimize sum(i in 1..N)(TranslatorSelection[i] * Cost[i]);