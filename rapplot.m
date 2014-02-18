function res = rapplot(lib,GUIV,plotConfig,PC)
  for k=1:length(plotConfig.id)
    % Setup path and add group if needed
    pth = 'output.curve(';
    if isfield(plotConfig,'group')
      pth = strcat(pth,plotConfig.group_id,plotConfig.id{k},').');
      rpLibPutString(lib,strcat(pth,'about.group'),plotConfig.group,0);
    else
      pth = strcat(pth,plotConfig.id{k},').');
    endif

    % Add Label
    rpLibPutString(lib,strcat(pth,'about.label'),plotConfig.label{k},0);

    % Add description
    if isfield(plotConfig,'description_suffix')
      rpLibPutString(lib,...
                     strcat(pth,'about.description'),...
                     strcat(plotConfig.description{k},...
                            ' ',...
                            plotConfig.description_suffix),...
                    0);
    else
      rpLibPutString(lib,...
                     strcat(pth,'about.description'),...
                     plotConfig.description{k},0);
    endif




endfunction
