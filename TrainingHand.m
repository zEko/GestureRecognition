
_FOUND_PALM_START = 0;
_FOUND_PALM_END = 0;
_innerbreak = false;
_start_of_palm = [0 0];
_end_of_palm = [0 0];
_palm_width = _end_of_palm(2)-_start_of_palm(2);
palm_repeat_count = 0;

for ir=1:1:((nr/2)) % scan from the top, hand is reversed
  for ic=1:nc
    if(object_image(ir,ic) == 1 )
      if(_FOUND_PALM_START == 0)
	_FOUND_PALM_START = 1;
	_start_of_palm = [ir ic];
      else 
	_end_of_palm = [ir ic];
	_FOUND_PALM_END = 1;
      end
    else
      if(_FOUND_PALM_END == 1)
	_palm_width = _end_of_palm(2) - _start_of_palm(2);
	if(_palm_width > 17)
	  palm_repeat_count = palm_repeat_count + 1;
	end
	break
      end
    end
  end
  if(_innerbreak)
    break
  end
  _FOUND_PALM_START = 0;
  _FOUND_PALM_END = 0;
end

palm_height_train = palm_repeat_count;