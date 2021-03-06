## Function to generate the figure meanlambda ~ prem for different loss scenarios
##  for a model food web with 300 consumer and 100 basal species (trophic levels are colour coded).
## Input: - data: tibble, - webs: name of web, - paramss: species input (can be a vector), 
##        - scenarioss: habitat loss scenarios (can be a vector), - spfs: focal species for patch loss
##        - a: 1st shape paraemter of the beta distr (Bayesian network), 
##        - b: 2nd shape paremeter of the beta distr (Bayesian network), 
##        - basal: TRUE/FALSE => if TRUE basal species are plotted as well, otherwise only consumer species, 
##        - ptitle: plot title.
## Ouput: - ggplot with number of patches removed on the x-axis and metapopulation capacity on the y-axis, 
##        - rows: habitat loss scenarios, cols: species input parameters (pi_i and xi_i). 

plot_patchloss <- function(data, webs, paramss, scenarioss, spfs, a, b, basals, ptitle, labnames){

  data <- data %>% filter(params %in% paramss) %>% 
    mutate(scenario=factor(scenario, levels=c("best-case scenario", "worst-case scenario", "random scenario")), 
        params=factor(params,levels=c(paramss[1],paramss[2], paramss[3], paramss[4])))

  ynames <- c("best-case", "worst-case", "random")
  names(ynames) <- c("best-case scenario", "worst-case scenario", "random scenario")
  
  ## Extract top species extinction:
  temp <- data %>% filter(web==webs, spf==spfs, scenario %in% scenarioss, 
                          params %in% paramss, alpha == a, beta == b) 
  topextinct <- temp %>% filter(species==topsp, lambda<1) %>%  ## NOTE: max(species) != topsp !!!
    group_by(web, params, scenario) %>% 
    summarise(minprem=min(prem)) %>% 
    ungroup 
  
  ## Define theme and colour palette:
  theme_set(theme_bw()) ## set black and white theme
  colourCount <- data$ITL %>% unique %>% length
  getPalette  <- colorRampPalette(brewer.pal((11),"RdYlBu"))
  cpalette <- rev(getPalette(colourCount+1))
  cpalette <- cpalette[-4]
  
  if(basals == FALSE) data <- data %>% filter(FT != "basal") 
  
  data %>% filter(web == webs, params %in% paramss, spf==spfs, alpha == a, beta == b, scenario %in% scenarioss) %>%
    group_by(web, params, scenario, prem, ITL) %>%
    summarise(meanlambda=mean(lambda,na.rm=TRUE), sdlambda=sd(lambda, na.rm=TRUE)) %>% ungroup %>% 
    rename(`Patches removed`=prem) %>%
    ggplot() +
    aes(x=`Patches removed`, y=meanlambda, colour=as.factor(ITL), fill=as.factor(ITL)) +
    scale_color_manual(values=cpalette) +
    scale_fill_manual(values=cpalette) +
    geom_hline(yintercept=1, linetype="dashed", alpha=0.3) +
    geom_vline(data = topextinct, aes(xintercept = minprem), linetype="dotdash", alpha=0.7) +
    geom_line(show.legend=FALSE) +
    geom_ribbon(aes(ymin=meanlambda-sdlambda, ymax=meanlambda+sdlambda),colour=NA, alpha=0.3) +
    facet_grid(scenario~params, 
        labeller=labeller(.rows = as_labeller(ynames), .cols = as_labeller(labnames, label_parsed))) +
    guides(fill=guide_legend(title="Trophic\nlevel", override.aes=list(size=8, alpha=1), reverse=TRUE)) +
    ggtitle(ptitle) +
    theme(text = element_text(size=20), 
          axis.text.x = element_text(angle=75, hjust=1), axis.title = element_text(size=22), 
          strip.text.y = element_text(size=19), strip.text.x = element_text(size=19),
          legend.text = element_text(size=22), legend.title = element_text(size=22)) +
    ylab("Metapopulation capacity")
}
