% Parameters
int: t_e = 3;          % minutes per electronic reading
int: t_r = 2;          % minutes per regular reading
int: T = 15000;        % total minutes available
int: min_r = 50;       % minimum regular patients
int: ratio = 2;        % electronic >= ratio * regular

% Variables
var 0..T div t_e: e;   % number of electronic readings
var 0..T div t_r: r;   % number of regular readings
var 0..(T div min(t_e,t_r)): total;

% Constraints
constraint t_e * e + t_r * r <= T;
constraint e >= ratio * r;
constraint r >= min_r;
constraint total = e + r;

% Objective
solve maximize total;