% Parameters
enum AREA = {A,B,C,D,E,F,G,H,I,J,K,L};

array[AREA, AREA] of bool: cover = array2d(AREA, AREA, [
%        A     B     C     D     E     F     G     H     I     J     K     L
        true, false, true, false, true, false, true, true,  true,  false, false, false, % A covers A,C,E,G,H,I
        false,true,  false,false,false,false,false,true,  true,  false, false, false, % B covers B,H,I
        true, false, true, false,false,false,true, true,  true,  false, false, false, % C covers A,C,G,H,I
        false,false,false,true, false,false,false,false,false,true,  false, false, % D covers D,J
        true, false,false,false,true, false,true, false, false, false, false, false, % E covers A,E,G
        false,false,false,false,false,true, false,false,false,true,  true,  false, % F covers F,J,K
        true, false,true, false,true, false,true, false, false, false, false, false, % G covers A,C,E,G
        true, true, true, false,false,false,false,true,  true,  false, false, false, % H covers A,B,C,H,I
        true, true, true, false,false,false,false,true,  true,  false, false, false, % I covers A,B,C,H,I
        false,false,false,true, false,true, false,false,false,true,  true,  true,  % J covers D,F,J,K,L
        false,false,false,false,false,true, false,false,false,true,  true,  true,  % K covers F,J,K,L
        false,false,false,false,false,false,false,false,false,true,  true,  true   % L covers J,K,L
]);

% Variables
array[AREA] of var bool: build;

% Constraints
constraint
  forall(a in AREA) (
    exists(s in AREA) (build[s] /\ cover[a,s])
  );

% Objective
solve minimize sum(a in AREA)(bool2int(build[a]));