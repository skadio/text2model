% Parameters (with values embedded)
int: hours_regular = 10;
int: cost_regular  = 300;
int: hours_emerg   = 6;
int: cost_emerg    = 100;

int: min_total_hours = 300;
int: budget = 7000;

% Variables
var 0..(budget div cost_regular): regular;
var 0..(budget div cost_emerg): emergency;

% Constraints
constraint hours_regular * regular + hours_emerg * emergency >= min_total_hours;
constraint cost_regular * regular + cost_emerg * emergency <= budget;

% Objective
solve minimize regular + emergency;