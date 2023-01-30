function [voro,areatot] = Voronoi_EdgeTreatment(voro, windowcour)
    % VORONOI_EDGETREATMENT checks whether the voronoi cells are entirely 
    % in a window of interest (especially Inf cases) and add to the 
    % structure two vectors containing the cells areas and normalized areas
    % Input : --voro the structures containing the voronoi cells
    %           --windowcour vector containing the [xmin xmax ymin ymax] of the
    %          window of interest
    % Output: --voro the same as input with two new fields containing the 
    %          cells area and normalized area with the total area
    %         --areatot thecells area
    %
    % Authors: L.F. may 2011, based on the LEGI package
    %           modified 10/5/11 : Dist_min added

    areatot=[];
    for Nimg=1:numel(voro),
        TessKey=voro(Nimg).TessKey;
        Tess=voro(Nimg).Tess;
        TessPx=voro(Nimg).TessPx;
        if ~isempty(Tess)
            % find out particles whose tesselation is fully into windowcour
            [goodvoronoi]=voronoi2voronoi_Window(Tess,TessKey,TessPx,windowcour);
            % fill-in the variables
            aire(:,1)=goodvoronoi(goodvoronoi(:,2)==1,1); aire(:,2)=Nimg;
            areatot=[areatot;aire];
            Ig=find(goodvoronoi(:,2)==1);
            voro(Nimg).voronoiarea=goodvoronoi(Ig,1);
            voro(Nimg).nvoronoiarea= goodvoronoi(Ig,1)/mean(goodvoronoi(Ig,1));
            clear goodvoronoi aire;
        else
            voro(Nimg).voronoiarea=[];
            voro(Nimg).nvoronoiarea=[];
            disp('..... empty voronoi file encountered')
        end
    end
end
