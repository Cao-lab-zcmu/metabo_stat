awk 'BEGIN {w=1;l=0} /SPC/{printf("%11s  %-2s  %3s %5d     %7.3f %7.3f %7.3f
  1.00  0.00\n"), $1, $2, "WAT", w, $5, $6, $7; l++} {if(l % 3 == 0) w++;}
!/SPC/{print $0}' desmondOut.pdb > waterFix.pdb


