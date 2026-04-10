% Parameters
int: ao_blueberries = 3;
int: min_blueberries = 5;
int: sugar_blueberries = 5;

int: ao_strawberries = 1;
int: min_strawberries = 7;
int: sugar_strawberries = 7;

int: req_ao = 90;
int: req_min = 100;

int: strawberry_to_blueberry_ratio = 3;

% Variables
var 0..1000: x_blueberries;
var 0..1000: x_strawberries;

var 0..1000000: total_sugar;

% Constraints
constraint
  ao_blueberries * x_blueberries + ao_strawberries * x_strawberries >= req_ao;

constraint
  min_blueberries * x_blueberries + min_strawberries * x_strawberries >= req_min;

constraint
  x_strawberries >= strawberry_to_blueberry_ratio * x_blueberries;

constraint
  total_sugar = sugar_blueberries * x_blueberries + sugar_strawberries * x_strawberries;

% Objective
solve minimize total_sugar;