% Parameters
int: mint_avail = 120;
int: active_avail = 100;
int: tar_max = 50;

int: mint1 = 10;
int: active1 = 20;
int: foam1 = 25;
int: tar1 = 5;

int: mint2 = 12;
int: active2 = 15;
int: foam2 = 18;
int: tar2 = 3;

% Variables
var 0..min(mint_avail div mint1, min(active_avail div active1, tar_max div tar1)): x1;
var 0..min(mint_avail div mint2, min(active_avail div active2, tar_max div tar2)): x2;

var 0..(foam1*(mint_avail div mint1) + foam2*(mint_avail div mint2)): total_foam;

% Constraints
constraint mint1*x1 + mint2*x2 <= mint_avail;
constraint active1*x1 + active2*x2 <= active_avail;
constraint tar1*x1 + tar2*x2 <= tar_max;

constraint total_foam = foam1*x1 + foam2*x2;

% Objective
solve maximize total_foam;