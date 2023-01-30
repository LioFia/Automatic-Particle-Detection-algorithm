function [goodvoronoi]=voronoi2voronoi_Window(Tess,TessKey,TessPx,windowloc)
%
% USE:
% [goodvoronoi]=voronoi2voronoi_Window(Tess,TessKey,windowloc);
%
% GOAL:
%
% From a Voronoi Tesselation and a spatial window gives which voronoi cells
% are fully included in the window. Also calculates the voronoi cells area
% INPUT:
%   Tess:       voronoi tesselation vertex positions (a Xx2 array)
%   TessKey:    voronoi tesselation keys (a Nx1 cell array of vectors)
%   windowloc:  window to be used to filter data. The format is the
%               following:
%                   xMin=windowloc(1);
%                   xMax=windowloc(2);
%                   yMin=windowloc(3);
%                   yMax=windowloc(4);
%
% OUTPUT:
%   goodvoronoi:    Nx2 vector sorted as TessKey
%                   - the first column contains 1 if the associated cell is
%                     within the window and 0 otherwise
%                   - the second column contains the cell area
%
% History of modifications:
%   100312: created by R. Monchaux
%   110429: modified by L. Fiabane : isinsquare is computed over a pixel
%   window, not a physical one
%
%%
disp([])
% if Tess is empty (particle outside the window or no particle detected),
% goodvoronoi is empty, otherwise check whether all vertices are inside
% window (goodvoronoi=[area 1]) or not (goodvoronoi=[NaN 0])
if ~isempty(Tess)
    % find out particles whose tesselation is partially out windowcour
%     [isinsquare]=insquare2(windowloc,TessPx');
    isinsquare = ones(length(TessPx),1);
    for ii = 1:length(TessPx)
        if (TessPx(ii,1)>windowloc(2) || TessPx(ii,1)<windowloc(1) || ...
            TessPx(ii,2)>windowloc(4) || TessPx(ii,2)<windowloc(3))
            isinsquare(ii) = 0;
        end
    end
    idout=find(isinsquare==0);
    goodvoronoi=NaN(length(TessKey),2);
    for kk=1:length(TessKey)
        Tc=TessKey{kk};
        Tc2=ismember(Tc,idout);
        if sum(Tc2)==0
            goodvoronoi(kk,1)=polyarea(Tess(Tc,1),Tess(Tc,2));
            goodvoronoi(kk,2)=1;
        else goodvoronoi(kk,1)=NaN;
            goodvoronoi(kk,2)=0;
        end
    end
else 
    goodvoronoi=[];
end