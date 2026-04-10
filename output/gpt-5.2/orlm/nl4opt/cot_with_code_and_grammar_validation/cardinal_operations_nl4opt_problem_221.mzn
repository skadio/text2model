% Parameters
int: red_avail = 80;
int: blue_avail = 70;
int: smelly_max = 10;

int: red1 = 3;
int: blue1 = 4;
int: green1 = 5;
int: smelly1 = 1;

int: red2 = 5;
int: blue2 = 3;
int: green2 = 6;
int: smelly2 = 2;

% Variables
var 0..min(red_avail div red1, min(blue_avail div blue1, smelly_max div smelly1)): x1; % # experiment 1
var 0..min(red_avail div red2, min(blue_avail div blue2, smelly_max div smelly2)): x2; % # experiment 2

var 0..(green1*(red_avail div red1) + green2*(red_avail div red2)): total_green;

% Constraints
constraint red1*x1 + red2*x2 <= red_avail;
constraint blue1*x1 + blue2*x2 <= blue_avail;
constraint smelly1*x1 + smelly2*x2 <= smelly_max;

constraint total_green = green1*x1 + green2*x2;

% Objective
solve maximize total_green;