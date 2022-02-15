% list available data files
if(~isdeployed)
  cd(fileparts(which(mfilename)));
end
DataPath = '.\';
AvailableFiles = dir((fullfile(DataPath, '*.csv')));

% Create mapfigure with default properties
mapfig = figure;

% Produce map animation to 25 frames
animated(1,1,1, 25) = 0;

% Open all data files.
%for idx = 1: size(AvailableFiles,1)
OpenFileName = "24HR_CBE_01.fig";
fig = openfig(OpenFileName);
% Assign X and Y values to LON & LAT
Longitude = double(fig.Children.Children.XData);
Latitude = double(fig.Children.Children.YData);
% close figure
close(gcf)

% Menu for user to choose map type
map_option = menu('Choose a map:','Default - (COLOURBLIND)','Jet - (COLOURBLIND)','HSV','Hot - (COLOURBLIND)','Cool',...
                                  'Spring','Summer','Autumn - (COLOURBLIND)','Winter - (COLOURBLIND)',...
                                  'Gray','Bone','Copper','Pink','Lines - (COLOURBLIND)',...
                                  'Colorcube','Prism','Flag','White');
% Assign user option to map choice
% Colourmap based off user choice
if map_option == 1
    colormap('Parula')
    cmap = colormap;
    
elseif map_option == 2
    colormap('Jet')
    cmap = colormap;
    
elseif map_option == 3
    colormap('HSV')
    cmap = colormap;
    
elseif map_option == 4
    colormap('Hot')
    cmap = colormap;
    
elseif map_option == 5
    colormap('Cool')
    cmap = colormap;
    
elseif map_option == 6
    colormap('Spring')
    cmap = colormap;
    
elseif map_option == 7
    colormap('Summer')
    cmap = colormap;
    
elseif map_option == 8
    colormap('Autumn')
    cmap = colormap;
    
elseif map_option == 9
    colormap('Winter')
    cmap = colormap;
    
elseif map_option == 10
    colormap('Gray')
    cmap = colormap;
    
elseif map_option == 11
    colormap('Bone')
    cmap = colormap;
    
elseif map_option == 12
    colormap('Copper')
    cmap = colormap;
    
elseif map_option == 13
    colormap('Pink')
    cmap = colormap;
    
elseif map_option == 14
    colormap('Lines')
    cmap = colormap;
    
elseif map_option == 15
    colormap('Colorcube')
    cmap = colormap;
    
elseif map_option == 16
    colormap('Prism')
    cmap = colormap;
    
elseif map_option == 17
    colormap('Flag')
    cmap = colormap;
    
elseif map_option == 18
    colormap('White')
    cmap = colormap;
end

    % Create the colourbar
    cbar = colorbar();
    % Reverse the colourbar
    set(cbar, 'YDir', 'reverse' );
    % Position colourbar to the left side of the figure
    cbar.Position = [0.05 0.15 0.01 0.8]; 
    % Set colourbar axis from 0 to 1
    caxis([0 1]);


% Loop from figure 1 to last figure.
for idx = 1: size(AvailableFiles,1)
    
    % Set Ozone value
    Ozone =  csvread(AvailableFiles(idx).name);
    worldmap('Europe'); % set the part of the earth to show
    
    
    % Import coastlines
    load coastlines
    % Plot coastlines
    plotm(coastlat,coastlon)
    
    % Assign LON, LAT & Ozone to map
    surfm(Latitude , Longitude, Ozone)
    
    %setm(gca, "mapprojection", "eqdcylin")
    
    % Map properties
    land = shaperead('landareas', 'UseGeoCoords', true);
    geoshow(gca, land, 'FaceColor', [0.5 0.7 0.5])

    lakes = shaperead('worldlakes', 'UseGeoCoords', true);
    geoshow(lakes, 'FaceColor', 'blue')

    rivers = shaperead('worldrivers', 'UseGeoCoords', true);
    geoshow(rivers, 'Color', 'blue')

    cities = shaperead('worldcities', 'UseGeoCoords', true);
    geoshow(cities, 'Marker', '.', 'Color', 'red')
    
    Plots = findobj ( gca, "Type", "Axes");
    Plots.SortMethod = "depth";
    
    % Get map in frame
    frame = getframe(gcf);
    
    % Writes to .GIF file
    % For figure 1
    if idx == 1
        % Assign animation & colourmap to it
        [animated, cmap] = rgb2ind(frame.cdata, 256, 'nodither');
    else
        % For the rest of the figures, keep the animation going
      animated(:,:,1,idx) = rgb2ind(frame.cdata, cmap, 'nodither');
    end
    
    % Name = strsplit(OpenFileName,'.');
    % Write to .csv
    %writematrix(Ozone, strcat(Name{1},'.csv'))

end
% Assign map to name
filename = "map.gif";
% Write image using map components
imwrite(animated, cmap, filename, 'DelayTime', 0.3, 'LoopCount', inf);
% Output map.gif
web(filename)