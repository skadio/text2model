int: N;                                                % Number of translators
int: M;                                                % Number of required languages

set of int: Translators = 1..N;
set of int: Languages   = 1..M;

array[Translators] of int: Cost;                       % Cost of hiring translator t
array[Translators, Languages] of 0..1: TranslatorLanguagesMatrix;  % Coverage matrix
array[Languages] of string: RequiredLanguages;         % Names of required languages (informative)

array[Translators] of var 0..1: hire;                  % 1 if translator t is selected

constraint
    forall(l in Languages) (
        sum(t in Translators) (hire[t] * TranslatorLanguagesMatrix[t,l]) >= 1
    );

solve minimize sum(t in Translators) (hire[t] * Cost[t]);