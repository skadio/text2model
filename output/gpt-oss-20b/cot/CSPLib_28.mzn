% Parameters
int: v;
int: k;
int: lambda;

int: b = (v*(v-1)*lambda) div (k*(k-1));
int: r = (lambda*(v-1)) div (k-1);

constraint (v*(v-1)*lambda) mod (k*(k-1)) = 0;
constraint (lambda*(v-1)) mod (k-1) = 0;

% Variables
array[1..b, 1..k] of var 1..v: blocks;

% Constraints
constraint forall(i in 1..b) (
    all_distinct([blocks[i,j] | j in 1..k])
);

constraint forall(o in 1..v) (
    sum([bool2int(blocks[i,j] == o) | i in 1..b, j in 1..k]) = r
);

constraint forall(o1 in 1..v-1, o2 in o1+1..v) (
    sum([ sum([bool2int(blocks[i,j1] == o1 /\ blocks[i,j2] == o2) | j1 in 1..k, j2 in j1+1..k]) | i in 1..b]) = lambda
);

% Objective
solve satisfy;