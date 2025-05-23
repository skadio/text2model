include "globals.mzn";

% Parameters
int: N; % Number of translators
array[1..N] of int: Cost; % Cost of translator i
array[1..N, 1..M] of 0..1: TranslatorLanguagesMatrix; % Set of languages that translator i can translate
int: M; % Number of required languages
array[1..M] of string: RequiredLanguages; % List of required languages

% Variables
array[1..N] of var 0..1: Translators; % Decision variable indicating whether a translator is selected or not

% Constraints
constraint forall(i in 1..M)(
    sum(j in 1..N)(Translators[j] * TranslatorLanguagesMatrix[j,i]) >= 1
); % Ensure all required languages can be translated

% Objective
var int: TotalCost = sum(i in 1..N)(Translators[i] * Cost[i]);
solve minimize TotalCost;

% Output
output [ "Total Cost: ", show(TotalCost), "\n" ] ++
[ if fix(Translators[i]) = 1 then "Translator " ++ show(i) ++ " is selected\n" else "" endif | i in 1..N ];