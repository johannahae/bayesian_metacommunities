# bayesian_metacommunities

Code accompanying the manuscript "A Bayesian network approach to trophic metacommunities shows habitat loss accelarates top species extinction rates", by Johanna Häussler, György Barabas and Anna Eklöf (submitted to ##, 2020). 

The directory "c_code" contains the code in C++ and Bash needed to generate the food webs (binary adjacency matrices). To generate the webs, run the "build_webs.sh" file. Successfully running this file requires:
(1) An installation of the C programming language
(2) The gsl library

The directory "code" contains all the source code in R needed to replicate the results in the manuscript. 
To run the simulations, run the "launch.R" file. This will create all necessary data and run all additional code automatically. Among others, it calls the function "run_instance.R" in which all the magic happens. Successfully running this file requires:
(1) An installation of the R programming language (version 3.0 or higher should work)
(2) Three additional R packages (igraph; NetIndices; tidyverse)

To generate the figures, run th "figure_script_manuscript.R" file. This file contains all code needed to recreate the figures in the manuscript, the file "figure_script_SI.R" contains a code example to recreate the figures in the SI. Successfully running these files requires:
(1) An installation of the R programming language (version 3.0 or higher should work)
(2) Four additional R packages (cowplot; magick; RColorBrewer; tidyverse)

All included code is covered under the GPL, version 3, available here: (http://www.gnu.org/licenses/gpl-3.0.en.html).

Any question about the code can be sent to Johanna Häussler (johanna.haeussler@idiv.de) and Györgi Barabas (gyorgy.barabas@liu.se). 
