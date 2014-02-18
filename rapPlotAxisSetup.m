function multi = rapPlotAxisSetup(lib,plotConfig,PC,pth,axis,k)
  multi = 1;
  tmp = {'label','units','description','scale'};
  for n=1:length(tmp)
    if isfield(plotConfig.(axis),tmp{n})
      rpLibPutString(lib,...
                     strcat(axis,'axis.',tmp{n}),...
                     plotConfig.(axis).(tmp{n}),0);
    endif
  endfor
  tmp = {'multiply','divide'};
  for n=1:length(tmp)
    if isfield(plotConfig.(axis),tmp{n})
      C = {};
      if ~iscell(plotConfig.(axis).(tmp{n}))
        C = mat2cell(plotConfig.(axis).(tmp{n}),...
                     ones(1,size(plotConfig.(axis).(tmp{n}),1)));
      else
        C = plotConfig.(axis).(tmp{n});
      endif

      for m=1:length(C)
        if iscell(C{m})
          key = C{m}{1};
          val = PC.(C{m}{2});
        else
          key = C{m}(1);
          val = C{m}(2);
        endif
        if ((key == 0) + (key == k))>0
          if (n==1)
            multi = multi.*val;
          else
            multi = multi./val;
          endif
        endif
      endfor
    endif
  endfor
endfunction
