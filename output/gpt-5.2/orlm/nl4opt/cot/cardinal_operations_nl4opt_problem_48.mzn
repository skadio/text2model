% Parameters (with values embedded)
int: cap_motorcycle = 30;
int: cap_sedan = 70;

int: pol_motorcycle = 4;
int: pol_sedan = 15;

int: earn_motorcycle = 100;
int: earn_sedan = 225;

int: max_pollution = 199;          % "less than 200"
int: min_people = 1200;

% Variables
var 0..1000: motorcycles;
var 0..1000: sedans;

var 0..1000000: total_people;
var 0..1000000: total_pollution;
var 0..1000000: total_earnings;

% Constraints
constraint total_people = cap_motorcycle * motorcycles + cap_sedan * sedans;
constraint total_pollution = pol_motorcycle * motorcycles + pol_sedan * sedans;
constraint total_earnings = earn_motorcycle * motorcycles + earn_sedan * sedans;

constraint total_people >= min_people;
constraint total_pollution <= max_pollution;

% At most 25% of vehicles are motorcycles:
% motorcycles <= 0.25 * (motorcycles + sedans)  <=>  4*motorcycles <= motorcycles + sedans  <=>  3*motorcycles <= sedans
constraint 3 * motorcycles <= sedans;

% Objective
solve maximize total_earnings;