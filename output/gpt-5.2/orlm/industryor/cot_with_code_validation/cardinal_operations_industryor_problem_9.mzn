% Parameters
enum AREA = {A,B,C,D,E,F,G,H,I,J,K,L};

array[AREA] of set of AREA: cover = [
  {A,C,E,G,H,I},        % A
  {B,H,I},              % B
  {A,C,G,H,I},          % C
  {D,J},                % D
  {A,E,G},              % E
  {F,J,K},              % F
  {A,C,E,G},            % G
  {A,B,C,H,I},          % H
  {A,B,C,H,I},          % I
  {D,F,J,K,L},          % J
  {F,J,K,L},            % K
  {J,K,L}               % L
];

% Variables
array[AREA] of var bool: build;

% Constraints
constraint
  forall(a in AREA) (
    exists(s in cover[a]) (build[s])
  );

% Objective
solve minimize sum(a in AREA)(bool2int(build[a]));