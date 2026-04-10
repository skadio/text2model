% Parameters
int: cap_motorcycle = 30;
int: cap_sedan = 70;

int: pol_motorcycle = 4;
int: pol_sedan = 15;

int: earn_motorcycle = 100;
int: earn_sedan = 225;

int: pol_limit = 199;          % "less than 200"
int: demand_people = 1200;

% Variables
var 0..1000: motorcycles;
var 0..1000: sedans;

var 0..1000000: total_earnings;

% Constraints
constraint
  cap_motorcycle * motorcycles + cap_sedan * sedans >= demand_people;

constraint
  pol_motorcycle * motorcycles + pol_sedan * sedans <= pol_limit;

% At most 25% of vehicles are motorcycles:
% motorcycles <= 0.25*(motorcycles+sedans)  <=>  3*motorcycles <= sedans
constraint
  3 * motorcycles <= sedans;

constraint
  total_earnings = earn_motorcycle * motorcycles + earn_sedan * sedans;

% Objective
solve maximize total_earnings;