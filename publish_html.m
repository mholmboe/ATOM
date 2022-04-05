%% This MATLAB .m file is used to generate the html-documentation
%
%% Version
% 2.11
%
%% Contact
% Please report problems/bugs to michael.holmboe@umu.se
%

%% Set the path's
atompath=pwd;
docpath=strcat(atompath,'/html');

%% The lists
filelist = {...
    'Available_functions.m',...
    'Common_variables.m',...
    'Examples.m',...
    'index.m',...
    'Structures_and_solvents.m',...
    'List_all_functions.m',...
    'List_build_functions.m',...
    'List_export_functions.m',...
    'List_forcefield_functions.m',...
    'List_general_functions.m',...
    'List_import_functions.m',...
    'List_neigh_functions.m',...
    'List_structures.m',...
    'List_variables.m',...
    };

for i=1:length(filelist)
    filelist{i}
    publish(filelist{i},'createThumbnail',true,'maxWidth',1200,'evalCode',false,'outputDir',docpath)
end

%% The functions, in each subfolder
dirs={...
    'build_functions';...
    'custom_functions';...
    'examples/Basic_examples';...
    'export_functions';...
    'external';...
    'forcefield_functions';...
    'general_functions';...
    'import_functions';...
    'neigh_functions';...
    'variables';...
    'structures';...
    'variables';...
    };

new_list={};
for j=1:size(dirs,1)
    
    cd(char(dirs(j)))
    filelist = dir('*.m')
    
    dirs(j)
    
    for i=1:size(filelist,1)
        
        if ~isfile(filelist(i).name)
            new_list={new_list;[dirs(j) filelist(i).name]};
            dirs(j)
            filelist(i).name
            pause
        end
        
        publish(filelist(i).name,'createThumbnail',true,'maxWidth',1200,'evalCode',false,'outputDir',docpath)
    end
    
    cd(atompath)
    
end

%% Lastly, build a searchable html-index
builddocsearchdb(docpath)

new_list


