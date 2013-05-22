function AB = bowing(A,B,C,wts)
if (length(wts) == 1)
   wts = [1-wts;wts];
endif
AB = A.*wts(1)+B.*wts(2)-prod(wts([1 2])).*C;

endfunction
