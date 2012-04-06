
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Palm Finder %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find the find continous line of object from the bottom of the image. 
% This will be assumed as the palm base, the palm height is assumed to 
% be 35px. A initial offset of 10px is ensures we can emit the false 
% positive,the border of box, in case it appears in the image.
%

FOUND_PALM_START = 0;
FOUND_PALM_END = 0;
innerbreak = false;
start_of_palm = [0 0];
end_of_palm = [0 0];
palm_width = end_of_palm(2)-start_of_palm(2);
palm_height = 1.6*palm_width;
palm_repeat_count = 0;
for ir=1:1:((nr/2)) % scan from the top, hand is reversed
  for ic=1:nc
    if(object_image(ir,ic) == 1 )
      if(FOUND_PALM_START == 0)
	FOUND_PALM_START = 1;
	start_of_palm = [ir ic];
      else 
	end_of_palm = [ir ic];
	FOUND_PALM_END = 1;
      end
    else
      if(FOUND_PALM_END == 1)
	palm_width = end_of_palm(2) - start_of_palm(2);
	if(palm_width > 15)
	  palm_repeat_count = palm_repeat_count + 1;
	end
	if(palm_repeat_count > 3)
	  innerbreak = true;
	end
	break
      end
    end
  end
  if(innerbreak)
    break
  end
  FOUND_PALM_START = 0;
  FOUND_PALM_END = 0;
end

palm_width = end_of_palm(2) - start_of_palm(2);
palm_centre = bitshift(palm_width,(-1)); % Divide by 2
