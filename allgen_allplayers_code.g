Read("~/.gap/gaprc");
LoadPackage("SgpDec");



experimentNum := 10; #increment by hand for new text file

#constants change depending on python file
POPULATION := 100;
GEN := 99;

outFile := Concatenation( "outGen", String(experimentNum),".txt");

for genIdx in [1..GEN] do
for playerIdx  in [1..POPULATION] do
   filename := Concatenation("./G", String(genIdx), "_P", String(playerIdx), ".g");
   Print(filename);
   Read(filename);

   Symbols:=["C", "D"];
   #assume C, D are defined in the files
   T := Semigroup([C,D]);

#breaks if there is only one state
   if Length(States) < 2 then
      cpxbound := 0;

   else
      sk := Skeleton(T);
      DisplayHolonomyComponents(sk);

      cpxbound := 0; 

      for dx in [1..DepthOfSkeleton(sk)-1] do
         no_holonomy_group_seen_yet_at_this_level := true;
         for  x1 in RepresentativeSets(sk)[dx] do
            px1 := PermutatorGroup(sk,x1);
            hx1 := HolonomyGroup@SgpDec(sk,x1); 
            if IsTrivial(hx1)  then
                trivialgroup := true;
            else  
                if no_holonomy_group_seen_yet_at_this_level then
                          cpxbound := cpxbound + 1;  
                          no_holonomy_group_seen_yet_at_this_level := false;
                fi;

            fi; 
         od;
      od;
   fi;
 
Print("\n cpxbounds:",cpxbound);
Print(":",Minimum([cpxbound,1]));
Print("\n");

#generation, complexity, number of states (third row of player file)
AppendTo(outFile, String(genIdx), " ", String(playerIdx), " ", String(cpxbound), " ", String(Length(States)), "\n");

   od;
od;
