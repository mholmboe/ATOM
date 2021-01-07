
<!DOCTYPE html
  PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
   <!--
This HTML was auto-generated from MATLAB code.
To make changes, update the MATLAB code and republish this document.
      --><title>The atom script library</title><meta name="generator" content="MATLAB 9.8"><link rel="schema.DC" href="http://purl.org/dc/elements/1.1/"><meta name="DC.date" content="2021-01-04"><meta name="DC.source" content="index.m"><style type="text/css">
html,body,div,span,applet,object,iframe,h1,h2,h3,h4,h5,h6,p,blockquote,pre,a,abbr,acronym,address,big,cite,code,del,dfn,em,font,img,ins,kbd,q,s,samp,small,strike,strong,sub,sup,tt,var,b,u,i,center,dl,dt,dd,ol,ul,li,fieldset,form,label,legend,table,caption,tbody,tfoot,thead,tr,th,td{margin:0;padding:0;border:0;outline:0;font-size:100%;vertical-align:baseline;background:transparent}body{line-height:1}ol,ul{list-style:none}blockquote,q{quotes:none}blockquote:before,blockquote:after,q:before,q:after{content:'';content:none}:focus{outine:0}ins{text-decoration:none}del{text-decoration:line-through}table{border-collapse:collapse;border-spacing:0}

html { min-height:100%; margin-bottom:1px; }
html body { height:100%; margin:0px; font-family:Arial, Helvetica, sans-serif; font-size:10px; color:#000; line-height:140%; background:#fff none; overflow-y:scroll; }
html body td { vertical-align:top; text-align:left; }

h1 { padding:0px; margin:0px 0px 25px; font-family:Arial, Helvetica, sans-serif; font-size:1.5em; color:#d55000; line-height:100%; font-weight:normal; }
h2 { padding:0px; margin:0px 0px 8px; font-family:Arial, Helvetica, sans-serif; font-size:1.2em; color:#000; font-weight:bold; line-height:140%; border-bottom:1px solid #d6d4d4; display:block; }
h3 { padding:0px; margin:0px 0px 5px; font-family:Arial, Helvetica, sans-serif; font-size:1.1em; color:#000; font-weight:bold; line-height:140%; }

a { color:#005fce; text-decoration:none; }
a:hover { color:#005fce; text-decoration:underline; }
a:visited { color:#004aa0; text-decoration:none; }

p { padding:0px; margin:0px 0px 20px; }
img { padding:0px; margin:0px 0px 20px; border:none; }
p img, pre img, tt img, li img, h1 img, h2 img { margin-bottom:0px; }

ul { padding:0px; margin:0px 0px 20px 23px; list-style:square; }
ul li { padding:0px; margin:0px 0px 7px 0px; }
ul li ul { padding:5px 0px 0px; margin:0px 0px 7px 23px; }
ul li ol li { list-style:decimal; }
ol { padding:0px; margin:0px 0px 20px 0px; list-style:decimal; }
ol li { padding:0px; margin:0px 0px 7px 23px; list-style-type:decimal; }
ol li ol { padding:5px 0px 0px; margin:0px 0px 7px 0px; }
ol li ol li { list-style-type:lower-alpha; }
ol li ul { padding-top:7px; }
ol li ul li { list-style:square; }

.content { font-size:1.2em; line-height:140%; padding: 20px; }

pre, code { font-size:12px; }
tt { font-size: 1.2em; }
pre { margin:0px 0px 20px; }
pre.codeinput { padding:10px; border:1px solid #d3d3d3; background:#f7f7f7; }
pre.codeoutput { padding:10px 11px; margin:0px 0px 20px; color:#4c4c4c; }
pre.error { color:red; }

@media print { pre.codeinput, pre.codeoutput { word-wrap:break-word; width:100%; } }

span.keyword { color:#0000FF }
span.comment { color:#228B22 }
span.string { color:#A020F0 }
span.untermstring { color:#B20000 }
span.syscmd { color:#B28C00 }
span.typesection { color:#A0522D }

.footer { width:auto; padding:10px 0px; margin:25px 0px 0px; border-top:1px dotted #878787; font-size:0.8em; line-height:140%; font-style:italic; color:#878787; text-align:left; float:none; }
.footer p { margin:0px; }
.footer a { color:#878787; }
.footer a:hover { color:#878787; text-decoration:underline; }
.footer a:visited { color:#878787; }

table th { padding:7px 5px; text-align:left; vertical-align:middle; border: 1px solid #d6d4d4; font-weight:bold; }
table td { padding:7px 5px; text-align:left; vertical-align:top; border:1px solid #d6d4d4; }





  </style></head><body><div class="content"><h1>The atom script library</h1><!--introduction--><p>Below is links to all functions, sorted after topic/purpose or alphabetically</p><!--/introduction--><h2>Contents</h2><div><ul><li><a href="#1">Version</a></li><li><a href="#2">How-to cite the atom library?</a></li><li><a href="#3">How-to use these documentation pages</a></li><li><a href="#5">Common variables</a></li><li><a href="#6">Examples</a></li><li><a href="#7">All available functions</a></li><li><a href="#8">Main types of variables</a></li><li><a href="#9">Available pre-equilibrated solvents</a></li></ul></div><h2 id="1">Version</h2><p>2.082</p><h2 id="2">How-to cite the atom library?</h2><div><ul><li>The atom library has been described in the following paper: atom: A MATLAB PACKAGE FOR MANIPULATION OF MOLECULAR SYSTEMS, Clays and Clay Minerals, Accepted November 2019. DOI:10.1007/s42860-019-00043-y</li></ul></div><h2 id="3">How-to use these documentation pages</h2><p>You can read and browse through these html pages in any browser you want, but you could also use these html files (which are part of the distribution) interactively via MATLAB's own browser by executing the code line by line after highlighting the code (using right-click) and choosing 'Evaluate selection' as illustrated below - or just press 'Shift+F7' as illustrated in the figure below.</p><p><img vspace="5" hspace="5" src="interactive_html.png" alt=""> </p><h2 id="5">Common variables</h2><div><ul><li><a href="List_variables.html">Main variables</a></li></ul></div><h2 id="6">Examples</h2><div><ul><li><a href="Basic_examples.html">Basic_examples</a></li><li><a href="Advanced_examples.html">Advanced_examples</a></li></ul></div><h2 id="7">All available functions</h2><div><ul><li><a href="List_all_functions.html">All functions sorted alphabetically</a></li><li><a href="List_build_functions.html">Functions for building molecular boxes</a></li><li><a href="List_forcefield_functions.html">Topology and forcefield specific functions</a></li><li><a href="List_general_functions.html">General functions</a></li><li><a href="List_export_functions.html">Export related functions</a></li><li><a href="List_import_functions.html">Import related functions</a></li></ul></div><h2 id="8">Main types of variables</h2><div><ul><li><a href="List_variables.html">List of the main types of variables used by this MATLAB library</a></li></ul></div><h2 id="9">Available pre-equilibrated solvents</h2><div><ul><li><a href="List_structures.html">List of available solvent structures and more</a></li></ul></div><p class="footer"><br><a href="https://www.mathworks.com/products/matlab/">Published with MATLAB&reg; R2020a</a><br></p></div><!--
##### SOURCE BEGIN #####
%% The atom script library
% Below is links to all functions, sorted after topic/purpose or alphabetically
%
%% Version
% 2.09
%
 
%% How-to cite the atom library?
% * The atom library has been described in the following paper:
% atom: A MATLAB PACKAGE FOR MANIPULATION OF MOLECULAR SYSTEMS, Clays and
% Clay Minerals, Accepted November 2019. DOI:10.1007/s42860-019-00043-y
 
%% How-to use these documentation pages
% You can read and browse through these html pages in any browser you want,
% but you could also use these html files (which are part of the distribution)
% interactively via MATLAB's own browser by executing the code line by line 
% after highlighting the code (using right-click) and choosing 
% 'Evaluate selection' as illustrated below - or just press 'Shift+F7' as 
% illustrated in the figure below.
%
%%
% <<interactive_html.png>>
 
%% Common variables
% * <List_variables.html Main variables>
 
%% Examples
% * <Basic_examples.html Basic_examples>
% * <Advanced_examples.html Advanced_examples>
 
%% All available functions
% * <List_all_functions.html All functions sorted alphabetically>
% * <List_build_functions.html Functions for building molecular boxes> 
% * <List_forcefield_functions.html Topology and forcefield specific functions> 
% * <List_general_functions.html General functions>
% * <List_export_functions.html Export related functions> 
% * <List_import_functions.html Import related functions> 
 
%% Main types of variables
% * <List_variables.html List of the main types of variables used by this MATLAB library>
 
%% Available pre-equilibrated solvents
% * <List_structures.html List of available solvent structures and more>

##### SOURCE END #####
--></body></html>