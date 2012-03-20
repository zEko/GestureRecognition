clc; clf; clear all; close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Group : r7, g21                 %%%
%%% College : RNSIT, WorldServe     %%%
%%% Project : Hand Sign recognition %%%
%%% Software : Octave               %%%
%%% Licence : GPLv3                 %%%
%%% Author : kAi                    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Webcam Capture Code %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Image acquisition
%
background_image = imread('bg.jpg');
image_in = imread('hand.jpg');


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
palm_width = uint32(0);
palm_centre = 0;
palm_repeat_count = 0;
for ir=nr-10:-1:((nr/2))
  for ic=1:nc
    if(object_image(ir,ic) == 1)
      if(FOUND_PALM_START == 0)
	FOUND_PALM_START = 1;
	start_of_palm = [ir ic];
      else 
	end_of_palm = [ir ic];
	FOUND_PALM_END = 1;
      end
    else
      if(FOUND_PALM_END == 1)
	palm_repeat_count = palm_repeat_count + 1;
	if(palm_repeat_count == 3) % to check three successive lines of palm
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Finger Matrix %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pinky_left = start_of_palm(2);
pinky_right = pinky_left+10;
pinky_bottom = start_of_palm(1)-palm_height;
pinky_top = pinky_bottom-30;
pinky_mat = object_image(pinky_top:pinky_bottom, pinky_left:pinky_right);

ring_left = pinky_right;
ring_right = ring_left+10;
ring_bottom = pinky_bottom-5; % ring_offset
ring_top = ring_bottom-30;
ring_mat = object_image(ring_top:ring_bottom, ring_left:ring_right);

middle_left = ring_right;
middle_right = middle_left+10;
middle_bottom = ring_bottom-5; % middle_offset
middle_top = middle_bottom-30;
middle_mat = object_image(middle_top:middle_bottom, middle_left:middle_right);

index_left = middle_right;
index_right = index_left+13;
index_bottom = middle_bottom-5; % index_offset
index_top = index_bottom-20;
index_mat = object_image(index_top:index_bottom, index_left:index_right);

thumb_left = end_of_palm(2)+10;
thumb_right = thumb_left+30;
thumb_bottom = end_of_palm(1); % thumb_offset
thumb_top = thumb_bottom-30;
thumb_mat = object_image(thumb_top:thumb_bottom, thumb_left:thumb_right);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Display %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
subplot(2,5,1:5)
imshow(object_image)
title('Hand')

subplot(256)
imshow(pinky_mat)
title('Pinky')

subplot(257)
imshow(ring_mat)
title('Ring')

subplot(258)
imshow(middle_mat)
title('Middle')

subplot(259)
imshow(index_mat)
title('Index')

subplot(2,5,10)
imshow(thumb_mat)
title('Thumb')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Finger Database %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mat = [pinky ring middle index thumb]
finger_db(1).mat = [0 0 0 1 0];
finger_db(1).name = 'one';
finger_db(2).mat = [0 0 1 1 0];
finger_db(2).name = 'two';
finger_db(3).mat = [0 0 1 1 1];
finger_db(3).name = 'three';
finger_db(4).mat = [0 1 1 1 1];
finger_db(4).name = 'four';
finger_db(5).mat = [1 1 1 1 1];
finger_db(5).name = 'five';
finger_db(6).mat = [0 1 1 1 0];
finger_db(6).name = 'six';
finger_db(7).mat = [1 0 1 1 0];
finger_db(7).name = 'seven';
finger_db(8).mat = [1 1 0 1 0];
finger_db(8).name = 'eight';
finger_db(9).mat = [1 1 1 0 0];
finger_db(9).name = 'nine';
finger_db(10).mat = [0 0 0 0 0];
finger_db(10).name = 'none';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Finger Identification %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
finger_mat = zeros(1,5);
pinky = 1;
ring = 2;
middle = 3;
index = 4;
thumb = 5;

pinky_total = numel(pinky_mat > 0);
pinky_threshold = 50;
pinky_true = (((numel(find(pinky_mat > 0)))/pinky_total)*100) > pinky_threshold;
if(pinky_true)
  finger_mat(pinky) = 1;
end

ring_total = numel(ring_mat > 0);
ring_threshold = 50;
ring_true = (((numel(find(ring_mat > 0)))/ring_total)*100) > ring_threshold;
if(ring_true)
  finger_mat(ring) = 1;
end

middle_total = numel(middle_mat > 0);
middle_threshold = 50;
middle_true = (((numel(find(middle_mat > 0)))/middle_total)*100) > middle_threshold;
if(middle_true)
  finger_mat(middle) = 1;
end

index_total = numel(index_mat > 0);
index_threshold = 50;
index_true = (((numel(find(index_mat > 0)))/index_total)*100) > index_threshold;
if(index_true)
  finger_mat(index) = 1;
end

thumb_total = numel(thumb_mat > 0);
thumb_threshold = 50;
thumb_true = (((numel(find(thumb_mat > 0)))/thumb_total)*100) > thumb_threshold;
if(thumb_true)
  finger_mat(thumb) = 1;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Finger output %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:9
  if finger_mat == finger_db(i).mat
    printf("\nThe sign is %s. \n", finger_db(i).name)
  end
end


