% Parameters
int: labrador_capacity = 7;
int: labrador_treats = 5;

int: golden_capacity = 10;
int: golden_treats = 6;

int: total_treats = 1500;

int: min_golden = 50;

int: percent_labrador_max_num = 60; % 60%
int: percent_labrador_max_den = 100;

% Variables
var 0..(total_treats div labrador_treats): labradors;
var min_golden..(total_treats div golden_treats): goldens;

var 0..(labrador_capacity * (total_treats div labrador_treats) + golden_capacity * (total_treats div golden_treats)): newspapers;

% Constraints
constraint labrador_treats * labradors + golden_treats * goldens <= total_treats;

% at most 60% of the dogs can be labradors:
% labradors <= 0.6 * (labradors + goldens)  <=>  100*labradors <= 60*(labradors+goldens)
constraint percent_labrador_max_den * labradors
          <= percent_labrador_max_num * (labradors + goldens);

constraint newspapers = labrador_capacity * labradors + golden_capacity * goldens;

% Objective
solve maximize newspapers;