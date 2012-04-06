
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Segmentation Method %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YCbCr separates luma and chrominance components. We require Cb and Cr
% to establish the skin color space
%

background_diff_seg = false;
skin_color_space_seg = false;
background_image = rgb2ycbcr(background_image);
image_in = rgb2ycbcr(image_in);
[nr nc nd] = size(image_in);
no_of_luma_pix = numel(find(background_image(:,:,1) < 60));
SEGMENTATION_DECIDER = bitshift(nr*nc, -3); % 1/8 of total pix

if (no_of_luma_pix > SEGMENTATION_DECIDER)
  background_diff_seg = true;
else
  skin_color_space_seg = true;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Color Space Segmentation %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A Skin color space is used to separate the skin and non-skin pixels in
% the image. 
%

if (skin_color_space_seg)
  skin_mat = zeros(nr, nc);
  for ir = 1:nr
    for ic = 1:nc
      if ((image_in(ir, ic, 1) > 0) && ...
	  (image_in(ir, ic, 1) < 255))% && ...
%	  (image_in(ir, ic, 2) > 30) && ...
%	  (image_in(ir, ic, 2) > 0) && ...
%	  (image_temp(ir, ic, 3) < 200) && ...
%	  (image_temp(ir, ic, 3) > 15))

        skin_mat(ir, ic) = 1;
      else
	skin_mat(ir, ic) = 0;
      end % if
    end % column loop
  end % row loop
  object_image = skin_mat;
end % end if


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Background Difference %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Subtract the captured scene/sign from the background image, to segment
% hand from background.
%

if (background_diff_seg)
  object_image = zeros(nr,nc);
  diff_values = background_image(:,:,1) - image_in(:,:,1);
  THRESHOLD = mean(max(diff_values));
  object_image = (diff_values > THRESHOLD);
end


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
palm_height = 39;
%palm_width = uint32(0);
palm_width = end_of_palm(2)-start_of_palm(2);
palm_centre = 0;
palm_repeat_count = 0;
palm_width_repeat = nc;
for ir=nr:-1:((nr/2))
  for ic=1:nc
    if(object_image(ir,ic) < 254)
      if(FOUND_PALM_START == 0)
	FOUND_PALM_START = 1;
	start_of_palm = [ir ic];
      else 
	end_of_palm = [ir ic];
	FOUND_PALM_END = 1;
      end
    else
      if(FOUND_PALM_END == 1)
	if((palm_width_repeat>10) && (palm_width_repeat > (end_of_palm(2) - start_of_palm(2) + 10)))
	  innerbreak = true;
	end
	palm_width_repeat = end_of_palm(2) - start_of_palm(2);
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
