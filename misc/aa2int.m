function intval  = aa2int(aa)
if(~isscalar(aa))
  intval = zeros(size(aa));
  for i=1:length(intval)
      if(iscellstr(aa))
        intval(i) = aa2int_scalar(aa{i});
      else if(isscalar(aa(i)))
          intval(i) = aa2int_scalar(aa(i));
          else
              intval(i,:) = aa2int(aa(i,:));
          end;
      end;
  end;
else
  intval = aa2int_scalar(aa);
end;
function intval  = aa2int_scalar(aa)
intval =0;
switch(aa)
case 'A',intval = 1;
case 'R',intval = 2;
case 'N',intval = 3;
case 'D',intval = 4;
case 'C',intval = 5;
case 'Q',intval = 6;
case 'E',intval = 7;
case 'G',intval = 8;
case 'H',intval = 9;
case 'I',intval = 10;
case 'L',intval = 11;
case 'K',intval = 12;
case 'M',intval = 13;
case 'F',intval = 14;
case 'P',intval = 15;
case 'S',intval = 16;
case 'T',intval = 17;
case 'W',intval = 18;
case 'Y',intval = 19;
case 'V',intval = 20;
otherwise intval =21;
end

