pdf(file='C:/Users/SimoesLabAdmin/Documents/pt_diversity_rates/updated_occurrence_analyses/model_8/reptilia_all_offset_biohpc/combined_10_contribution_per_species_rates.pdf', width = 7, height = 6, useDingbats = FALSE, pointsize = 7)

ord_by_importance = function(s, consrank, rate_mean) {
  imp = consrank**2
  s = scale(s)
  imp = imp / sum(imp)
  #imp = imp / max(imp)
  s = t(t(s) * imp)
  p = prcomp(cbind(s, scale(rate_mean)))
  ord <- order(p$x[, 1])
  if (cor(1:length(rate_mean), rate_mean[ord]) < 0) {
     ord = order(p$x[, 1], decreasing = TRUE)
  }
  return(ord)
}

is_discrete <- function(x) {
  s = min(x):max(x)
  any(x == 0) && length(s) > 1 && all(s %in% unique(x))
}

combine_predictors <- function(shap, feat, feat_names, n_comb) {
  n_comb1 = n_comb + 1
  idx_comb = n_comb1:ncol(shap)
  shap[, n_comb1] = rowSums(shap[, idx_comb])
  shap = shap[, 1:n_comb1]
  comb_pred = t(do.call('rbind', feat[idx_comb]))
  pc1 = prcomp(comb_pred)$x[, 1]
  feat[[n_comb1]] = pc1
  feat[(n_comb + 2):(length(feat))] = NULL
  feat_names = feat_names[1:n_comb1]
  feat_names[n_comb1] = 'PC1 other predictors'
  out = vector(mode = 'list', length = 3)
  out[[1]] = shap
  out[[2]] = feat
  out[[3]] = feat_names
  return(out)
}

shap_heatmap <- function(shap, baseline, rates, species_names, feat,
                         feat_names, feat_states, rate_type = 'speciation', n_individual_pred = NULL) {
  nfeat = ncol(shap)
  if (!is.null(n_individual_pred)) {
    if ((n_individual_pred + 1) < nfeat) {
      comb_p = combine_predictors(shap, feat, feat_names, n_individual_pred)
      shap = comb_p[[1]]
      feat = comb_p[[2]]
      feat_names = comb_p[[3]]
      nfeat = ncol(shap)
    }
  }
  nspecies = nrow(shap)
  shap_pos = shap > 0
  shap_neg = shap < 0
  shap_sqrt = shap
  shap_sqrt[shap == 0] = 0
  offset_sqrt = 0.0
  shap_sqrt[shap_pos] = sqrt(shap[shap_pos] + offset_sqrt)
  shap_sqrt[shap_neg] = sqrt(-1 * shap[shap_neg] + offset_sqrt)
  max_pos = max(shap_sqrt[shap_pos])
  max_neg = max(shap_sqrt[shap_neg])
  steps_pos = round(max_pos / (max_pos + max_neg), 2) * 200
  steps_neg = round(max_neg / (max_pos + max_neg), 2) * 200
  # BrBG diverging colors
  total_steps = steps_pos + steps_neg
  max_steps = max(c(steps_pos, steps_neg))
  col_pos = colorRampPalette(c('#F5F5F5', '#543005'))(max_steps)
  col_neg = colorRampPalette(c('#F5F5F5', '#003C30'))(max_steps)
  col_pos = col_pos[1:steps_pos]
  col_neg = col_neg[1:steps_neg]
  shap_col = shap
  shap_col[shap == 0] = '#F5F5F5'
  col_idx = findInterval(shap_sqrt[shap_pos], seq(sqrt(offset_sqrt), max_pos, length.out = steps_pos), all.inside = TRUE)
  shap_col[shap_pos] = col_pos[col_idx]
  col_idx = findInterval(shap_sqrt[shap_neg], seq(sqrt(offset_sqrt), max_neg, length.out = steps_neg), all.inside = TRUE)
  shap_col[shap_neg] = col_neg[col_idx]
  species_names = gsub('_', ' ', species_names)
  # Plot
  h = 0.15
  if (nfeat < 10) {
    h = seq(0.4, 0.1, length.out = 9)
    h = h[nfeat]
  }
  heights = c(h, rep((1 - 1.25 * h)/nfeat, nfeat), h/4)
  rate_name = 'Speciation rate'
  rate_col = 'dodgerblue'
  if (rate_type == 'extinction') {
    rate_name = 'Extinction rate'
    rate_col = 'red'
  }
  if (rate_type == 'sampling') {
    rate_name = 'Sampling rate'
    rate_col = 'burlywood2'
  }
  layout(cbind(c(1, 2:(nfeat+2)), c(nfeat + 3, rep(nfeat + 4, nfeat), nfeat + 5)),
         heights = heights, widths = c(0.9, 0.1))
  # Rates per species
  par(las = 1, mar = c(0.1, 6, 0.5, 0.1), mgp = c(5, 1, 0))
  cex_lab = 2 / sqrt(length(feat_names))
  cex_lab = ifelse(cex_lab > 1, 1, cex_lab)
  y_tck = pretty(range(rates, na.rm = TRUE), n = 5)
  plot(0, 0, type = 'n', xaxs = 'i', yaxs = 'i',
       xlim = c(0, nspecies), ylim = range(y_tck),
       axes = FALSE, ylab = rate_name, cex.lab = cex_lab)
  abline(h = baseline, lty = 2, col = 'grey')
  x = c(1:nspecies) - 0.5
  polygon(c(x, rev(x)), c(rates[, 2], rev(rates[, 3])), col = adjustcolor(rate_col, alpha = 0.25), border = NA)
  lines(x, rates[, 1], col = rate_col, lwd = 1.5)
  axis(side = 2, at = y_tck, cex.axis = cex_lab)
  # Shape values
  species_x = c(1:nspecies) - 0.5
  for (i in 1:nfeat) {
    f = feat[[i]]
    if (is.null(dim(f))) {
      d = is_discrete(f)
      y_tck = pretty(range(f), n = 5)
      ylim = range(y_tck)
      if (d) {
        ylim = c(min(f) - 0.5, max(f) + 0.5)
      }
      plot(species_x, f, type = 'n', ylim = ylim,
           xlim = c(0, nspecies), xaxs = 'i', axes = FALSE,
           xlab = '', ylab = feat_names[i], cex.lab = cex_lab)
      if (!d) {
        lines(species_x, f, col = 'grey')
        axis(side = 2, at = y_tck, cex.axis = cex_lab)
      }
      else {
        axis(side = 2, at = min(f):max(f), cex.axis = cex_lab)
      }
      points(species_x, f, pch = 19, col = shap_col[, i])
    }
    else {
      nr = nrow(f)
      plot(0, 0, type = 'n', ylim = c(1 - 0.5, nr + 0.5),
           xlim = c(0, nspecies), xaxs = 'i', axes = FALSE,
           xlab = '', ylab = feat_names[i], cex.lab = cex_lab)
      axis(side = 2, at = 1:nr, labels = feat_states[[i]], cex.axis = cex_lab)
      for (j in 1:nr) {
        fj = f[j, ]
        idx = fj == 1
        points(species_x[idx], rep(j, sum(idx)), pch = 19, col = shap_col[idx, i])
      }
    }
  }
  # Species names
  par(mar = c(0.1, 6, 0.5, 0.1), mgp = c(3, 0.1, 0))
  plot(0, 0, type = 'n', xlim = c(0, nspecies), ylim = c(0, 3),
       xaxs = 'i', axes = FALSE, xlab = '', ylab = '')
  text(x = species_x, y = 3, labels = species_names,
       xpd = NA, srt = 35, adj = 0.965,
       cex = 4 / sqrt(length(species_names)), font = 3)
  # Empty plot
  plot(0, 0, type = 'n', axes = FALSE, xlab = '', ylab = '')
  # Legend
  col = c(rev(col_neg), col_pos)
  n_lead_digit = nchar(as.character(max(round(abs(shap)))))
  par(mar = c(4, 0.5, 0.5, 0.5), mgp = c(3, 1, 0))
  plot(0, 0, type = 'n', xlab = '', ylab = '', axes = FALSE,
       xlim = c(0, 2), ylim = c(0, 1.05 * total_steps))
  for (j in 1:total_steps) {
    rect(0, j - 1, 0.7, j, border = col[j], col = col[j])
  }
  rect(0, 0, 0.7, total_steps, border = 'black')
  lines(x = c(0.7, 1.0), y = rep(steps_neg, 2))
  text(x = 0, y = 1.05 * total_steps, labels = 'Rate change', adj = c(0, 0.5))
  a = c(1, 0.5) # right align
  text(x = 2, y = steps_neg, labels = sprintf(paste0('%.', 3 - n_lead_digit, 'f'), 0), adj = a)
  n_tck = 4
  s = seq(sqrt(offset_sqrt), max(c(max_pos, max_neg)), length.out = n_tck)
  pos = (s / s[n_tck]) * max_steps
  pos = pos[-1]
  s = s[-1]
  for (i in 1:length(pos)) {
    p = steps_neg + pos[i]
    if (p <= total_steps) {
      lines(x = c(0.7, 1.0), y = rep(p, 2))
      text(x = 2, y = p, adj = a, labels = sprintf(paste0('%.', 3 - n_lead_digit, 'f'), s[i]**2))
    }
    p = steps_neg - pos[i]
    if (p >= 0) {
      lines(x = c(0.7, 1.0), y = rep(p, 2))
      text(x = 2, y = p, adj = a, labels = sprintf(paste0('%.', 3 - n_lead_digit, 'f'), -(s[i]**2)))
    }
  }
}

consrank=c(2.0, 3.0,1.0,0.0,6.0,5.0,4.0)
consrank2 = order(consrank, decreasing = FALSE)
consrank = order(consrank, decreasing = TRUE)
shap_list = list()
shap_list[[1]]=c(0.044609780744690866,0.02608134349718825)
shap_list[[2]]=c(0.1752764731687255,-0.1455238655935714)
shap_list[[3]]=c(-0.36851956908496575,0.14460044429827756)
shap_list[[4]]=c(0.2016053015466917,0.10870175416511686)
shap_list[[5]]=c(0.013366834977582592,0.006339030692290713)
shap_list[[6]]=c(0.030590899061281675,0.018410382095248215)
shap_list[[7]]=c(-0.034591795111784784,-0.01896531726672131)
shap = do.call('cbind', shap_list)
baseline = 0.20937311040237547
rate=c(0.634135639054075,1.1017809161049081)
rate_lwr=c(0.16252881847321987,0.34571292251348495)
rate_upr=c(1.263320680707693,1.914509910158813)
rates = cbind(rate, rate_lwr, rate_upr)
species_names = c()
species_names = c(species_names, 'Feralisaurus')
species_names = c(species_names, 'Guchengosuchus')
feat_names = c()
feat_names = c(feat_names, 'lat_range_z_trans')
feat_names = c(feat_names, 'Temperate_N')
feat_names = c(feat_names, 'Tropical')
feat_names = c(feat_names, 'Temperate_S')
feat_names = c(feat_names, 'Antarctic')
feat_names = c(feat_names, 'mean_pt_1myr_z_trans')
feat_names = c(feat_names, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
ord = ord_by_importance(shap, consrank, rate)
shap_ord = shap[ord, consrank2, drop = FALSE]
rates_ord = rates[ord, ]
species_names_ord = species_names[ord]
feat_names_ord = feat_names[consrank2]
feat = vector(mode = 'list', length = 7)
feat_states = vector(mode = 'list', length = 7)
tmp = vector(mode = 'list', length = 11)
tmp_states = c()
tmp[[1]]=c(-0.3368251919746399,-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[18]]=c(-0.3368251919746399,-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[35]]=c(-0.3368251919746399,-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[52]]=c(-0.3368251919746399,-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[69]]=c(-0.3368251919746399,-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[86]]=c(-0.3368251919746399,-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[103]]=c(-0.3368251919746399,-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[120]]=c(-0.3368251919746399,-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[137]]=c(-0.3368251919746399,-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[154]]=c(-0.3368251919746399,-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[171]]=c(-0.3368251919746399,-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp = do.call('rbind', tmp)
feat[[1]] = tmp[, ord]
feat_states[[1]] = tmp_states
tmp = vector(mode = 'list', length = 11)
tmp_states = c()
tmp[[2]]=c(0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[19]]=c(0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[36]]=c(0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[53]]=c(0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[70]]=c(0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[87]]=c(0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[104]]=c(0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[121]]=c(0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[138]]=c(0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[155]]=c(0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[172]]=c(0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp = do.call('rbind', tmp)
feat[[2]] = tmp[, ord]
feat_states[[2]] = tmp_states
tmp = vector(mode = 'list', length = 11)
tmp_states = c()
tmp[[3]]=c(1.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[20]]=c(1.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[37]]=c(1.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[54]]=c(1.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[71]]=c(1.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[88]]=c(1.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[105]]=c(1.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[122]]=c(1.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[139]]=c(1.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[156]]=c(1.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[173]]=c(1.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp = do.call('rbind', tmp)
feat[[3]] = tmp[, ord]
feat_states[[3]] = tmp_states
tmp = vector(mode = 'list', length = 11)
tmp_states = c()
tmp[[4]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[21]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[38]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[55]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[72]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[89]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[106]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[123]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[140]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[157]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[174]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp = do.call('rbind', tmp)
feat[[4]] = tmp[, ord]
feat_states[[4]] = tmp_states
tmp = vector(mode = 'list', length = 11)
tmp_states = c()
tmp[[5]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[22]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[39]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[56]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[73]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[90]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[107]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[124]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[141]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[158]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[175]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp = do.call('rbind', tmp)
feat[[5]] = tmp[, ord]
feat_states[[5]] = tmp_states
tmp = vector(mode = 'list', length = 11)
tmp_states = c()
tmp[[6]]=c(1.3851090669631958,1.3851090669631958)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[23]]=c(1.3851090669631958,1.3851090669631958)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[40]]=c(1.3851090669631958,1.3851090669631958)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[57]]=c(1.3851090669631958,1.3851090669631958)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[74]]=c(1.3851090669631958,1.3851090669631958)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[91]]=c(1.3851090669631958,1.3851090669631958)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[108]]=c(1.3851090669631958,1.3851090669631958)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[125]]=c(1.3851090669631958,1.3851090669631958)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[142]]=c(1.3851090669631958,1.3851090669631958)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[159]]=c(1.3851090669631958,1.3851090669631958)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[176]]=c(1.3851090669631958,1.3851090669631958)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp = do.call('rbind', tmp)
feat[[6]] = tmp[, ord]
feat_states[[6]] = tmp_states
tmp = vector(mode = 'list', length = 11)
tmp_states = c()
tmp[[7]]=c(0.25894632935523987,0.25894632935523987)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[24]]=c(0.25894632935523987,0.25894632935523987)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[41]]=c(0.25894632935523987,0.25894632935523987)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[58]]=c(0.25894632935523987,0.25894632935523987)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[75]]=c(0.25894632935523987,0.25894632935523987)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[92]]=c(0.25894632935523987,0.25894632935523987)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[109]]=c(0.25894632935523987,0.25894632935523987)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[126]]=c(0.25894632935523987,0.25894632935523987)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[143]]=c(0.25894632935523987,0.25894632935523987)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[160]]=c(0.25894632935523987,0.25894632935523987)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[177]]=c(0.25894632935523987,0.25894632935523987)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp = do.call('rbind', tmp)
feat[[7]] = tmp[, ord]
feat_states[[7]] = tmp_states
feat_ord = feat[consrank2]
feat_states_ord = feat_states[consrank2]
shap_heatmap(shap_ord, baseline, rates_ord, species_names_ord, feat_ord,
             feat_names_ord, feat_states_ord, rate_type = 'speciation', n_individual_pred = 3)

consrank=c(1.0, 2.0,0.0,0.0,5.0,4.0,3.0)
consrank2 = order(consrank, decreasing = FALSE)
consrank = order(consrank, decreasing = TRUE)
shap_list = list()
shap_list[[1]]=c(0.09015847019851207, 0.055010028604182214,0.06266023706962626,0.05951813061569995,0.06333572830593497,0.03678690655789029,0.043406594543342496,0.037552916265990104,0.05977978358322902,0.06664397161238594,0.03693649228584698,0.041564059049787085,0.0554554810014606,0.05984733493865734,0.03912393755275523,0.05304184038027518,0.05325459596416718,0.03564841277101985,0.05969421159958883,0.04015033548936288,0.06131046881780023,0.03744910013894727)
shap_list[[2]]=c(0.254053947031498, 0.14315846098181226,0.1627156461479304,0.15231908654678974,0.16816271342362515,-0.10340521613810576,-0.16408822415893773,-0.11158322667717648,0.15508802170925912,0.17226590049309348,-0.10015500868039062,-0.16221269724808043,0.14394335007246192,0.15569308023958825,-0.11559194033563497,0.13630922428277062,0.13759786084482223,-0.09371979992546343,0.1543649345134679,-0.1417454602224726,0.15930924260727777,-0.1071004174364675)
shap_list[[3]]=c(0.41643872365355494, -0.2298946912134348,-0.2798279147772197,-0.26052241565358697,-0.2854592029646063,0.14492457271108264,0.17449575613000237,0.14289256633085815,-0.2554983449764495,-0.3084931355893716,0.1403461798931188,0.171009743113121,-0.23323427203167715,-0.274681314490029,0.1509286730769444,-0.2303243056226712,-0.22106236590527767,0.13568045021535297,-0.2670177847507295,0.16307283370011028,-0.2826433031542545,0.14341232967514048)
shap_list[[4]]=c(-1.049761049747467, 0.12134485604490695,0.13919292028902946,0.12928595904918885,0.14258561721315668,0.07665569208789615,0.09247775876783042,0.07568301854559037,0.13301907992459883,0.14710129725554716,0.07416468826545296,0.09002000369483047,0.12285064958056766,0.13231041433124033,0.08016852640084357,0.11547951622052369,0.11696250895002866,0.07149785442362688,0.13140654193126838,0.08578312876981392,0.1350153044097049,0.07631803662443139)
shap_list[[5]]=c(0.018197823797145248, 0.008172503692760243,0.01008106515655206,0.009566381896823477,0.010707956105269645,0.003909662774120898,0.00560454591290501,0.004144101410636525,0.009777817650820914,0.010710428767985175,0.003946631476521823,0.005338391191505391,0.008215640276738052,0.009718019018998993,0.0045561482617632355,0.007632421540663783,0.008001080468968599,0.0037367117678423403,0.009523658971529209,0.004725605199697317,0.009646367581867479,0.0043825363020337385)
shap_list[[6]]=c(0.02827659182017669, 0.005144121832403367,-0.004084281186862367,0.04311231221766183,0.012540414387940345,0.011540986030466367,0.03685813116481324,0.001011226682073156,-0.005442009017367489,0.013503576930203738,-0.001107311306051422,0.047393533949486866,0.02988311402910309,0.03533980225154054,-0.006691277783587588,0.031891878325931405,-5.982495927524332e-05,0.013928120090653388,0.031176108941097326,0.040258478604032984,0.004509588402465397,-0.005396457108935978)
shap_list[[7]]=c(-0.002368374210782349, 0.008058465404527973,-0.008905633524917756,-0.041203968756422175,-0.03633940490666446,0.005512296443066779,-0.044763297507604397,0.02252757837210388,-0.002048228529071245,-0.038636337538430814,0.023434795465042558,-0.044876553152747994,-0.01964734097972595,-0.030721557367270377,0.015422989081645537,0.000778802347569112,0.024340549138570273,0.013773507893704042,-0.029076187542742275,-0.03407552637465287,-0.0051039116466567854,0.024027317069264982)
shap = do.call('cbind', shap_list)
baseline = 0.23391521397978068
rate=c(0.3170919791922461, 0.8141131703874634,0.7392545856015932,0.78613407634115,0.72518298370509,1.2657776188232492,1.0679265570660936,1.3011572299838463,0.7591698027313396,0.7135113625878148,1.3163609053223626,1.095733276894025,0.812274623703197,0.7762285242448707,1.2250006526276866,0.8616691387640094,0.8405160997109488,1.3714853000085714,0.7771589691184636,1.1405208016600228,0.7591367721993447,1.2849768367979413)
rate_lwr=c(0.019796247826889157, 0.20821672677993774,0.2487051822245121,0.1343570714816451,0.14257514476776123,0.46284762024879456,0.2549532279372215,0.3421246870420873,0.25082202907651663,0.18030017986893654,0.4900967562571168,0.361320573836565,0.32169951125979424,0.1343570714816451,0.3647961914539337,0.27749388851225376,0.2622087672352791,0.5396266840398312,0.14257514476776123,0.20547587051987648,0.21225843206048012,0.4473008867353201)
rate_upr=c(0.7132031135261059, 1.3330690236762166,1.2565381117165089,1.4572464562952518,1.3921103905886412,2.6656040102243423,1.7875528559088707,2.3630309589207172,1.289994194972678,1.2884298460558057,2.453801137395203,2.1566678220406175,1.4930321611464024,1.386225512251258,2.397279778495431,1.4930321611464024,1.3239079229533672,2.673383167013526,1.3216382786631584,2.1566678220406175,1.3241729782894254,2.5105164386332035)
rates = cbind(rate, rate_lwr, rate_upr)
species_names = c()
species_names = c(species_names, 'Asperoris')
species_names = c(species_names, 'Atopodentatus')
species_names = c(species_names, 'Augustasaurus')
species_names = c(species_names, 'Diandongosaurus')
species_names = c(species_names, 'Dianopachysaurus')
species_names = c(species_names, 'Doliovertebra')
species_names = c(species_names, 'Eifelosaurus')
species_names = c(species_names, 'Halazhaisuchus')
species_names = c(species_names, 'Hescheleria')
species_names = c(species_names, 'Honghesaurus')
species_names = c(species_names, 'Jushatyria')
species_names = c(species_names, 'Koiloskiosaurus')
species_names = c(species_names, 'Luopingosaurus')
species_names = c(species_names, 'Marcianosuchus')
species_names = c(species_names, 'Megachirella')
species_names = c(species_names, 'Panzhousaurus')
species_names = c(species_names, 'Qianosuchus')
species_names = c(species_names, 'Sarmatosuchus')
species_names = c(species_names, 'Thalattoarchon')
species_names = c(species_names, 'Trachelosaurus')
species_names = c(species_names, 'Xinminosaurus')
species_names = c(species_names, 'Youngosuchus')
feat_names = c()
feat_names = c(feat_names, 'lat_range_z_trans')
feat_names = c(feat_names, 'Temperate_N')
feat_names = c(feat_names, 'Tropical')
feat_names = c(feat_names, 'Temperate_S')
feat_names = c(feat_names, 'Antarctic')
feat_names = c(feat_names, 'mean_pt_1myr_z_trans')
feat_names = c(feat_names, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
ord = ord_by_importance(shap, consrank, rate)
shap_ord = shap[ord, consrank2, drop = FALSE]
rates_ord = rates[ord, ]
species_names_ord = species_names[ord]
feat_names_ord = feat_names[consrank2]
feat = vector(mode = 'list', length = 7)
feat_states = vector(mode = 'list', length = 7)
tmp = vector(mode = 'list', length = 11)
tmp_states = c()
tmp[[1]]=c(-0.3368251919746399, -0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[18]]=c(-0.3368251919746399, -0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[35]]=c(-0.3368251919746399, -0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[52]]=c(-0.3368251919746399, -0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[69]]=c(-0.3368251919746399, -0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[86]]=c(-0.3368251919746399, -0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[103]]=c(-0.3368251919746399, -0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[120]]=c(-0.3368251919746399, -0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[137]]=c(-0.3368251919746399, -0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[154]]=c(-0.3368251919746399, -0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[171]]=c(-0.3368251919746399, -0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399,-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp = do.call('rbind', tmp)
feat[[1]] = tmp[, ord]
feat_states[[1]] = tmp_states
tmp = vector(mode = 'list', length = 11)
tmp_states = c()
tmp[[2]]=c(0.0, 0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,1.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,1.0,0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[19]]=c(0.0, 0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,1.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,1.0,0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[36]]=c(0.0, 0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,1.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,1.0,0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[53]]=c(0.0, 0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,1.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,1.0,0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[70]]=c(0.0, 0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,1.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,1.0,0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[87]]=c(0.0, 0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,1.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,1.0,0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[104]]=c(0.0, 0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,1.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,1.0,0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[121]]=c(0.0, 0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,1.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,1.0,0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[138]]=c(0.0, 0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,1.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,1.0,0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[155]]=c(0.0, 0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,1.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,1.0,0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[172]]=c(0.0, 0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,1.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,1.0,0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp = do.call('rbind', tmp)
feat[[2]] = tmp[, ord]
feat_states[[2]] = tmp_states
tmp = vector(mode = 'list', length = 11)
tmp_states = c()
tmp[[3]]=c(0.0, 1.0,1.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,0.0,0.0,1.0,1.0,0.0,1.0,1.0,0.0,1.0,0.0,1.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[20]]=c(0.0, 1.0,1.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,0.0,0.0,1.0,1.0,0.0,1.0,1.0,0.0,1.0,0.0,1.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[37]]=c(0.0, 1.0,1.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,0.0,0.0,1.0,1.0,0.0,1.0,1.0,0.0,1.0,0.0,1.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[54]]=c(0.0, 1.0,1.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,0.0,0.0,1.0,1.0,0.0,1.0,1.0,0.0,1.0,0.0,1.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[71]]=c(0.0, 1.0,1.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,0.0,0.0,1.0,1.0,0.0,1.0,1.0,0.0,1.0,0.0,1.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[88]]=c(0.0, 1.0,1.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,0.0,0.0,1.0,1.0,0.0,1.0,1.0,0.0,1.0,0.0,1.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[105]]=c(0.0, 1.0,1.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,0.0,0.0,1.0,1.0,0.0,1.0,1.0,0.0,1.0,0.0,1.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[122]]=c(0.0, 1.0,1.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,0.0,0.0,1.0,1.0,0.0,1.0,1.0,0.0,1.0,0.0,1.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[139]]=c(0.0, 1.0,1.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,0.0,0.0,1.0,1.0,0.0,1.0,1.0,0.0,1.0,0.0,1.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[156]]=c(0.0, 1.0,1.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,0.0,0.0,1.0,1.0,0.0,1.0,1.0,0.0,1.0,0.0,1.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[173]]=c(0.0, 1.0,1.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,0.0,0.0,1.0,1.0,0.0,1.0,1.0,0.0,1.0,0.0,1.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp = do.call('rbind', tmp)
feat[[3]] = tmp[, ord]
feat_states[[3]] = tmp_states
tmp = vector(mode = 'list', length = 11)
tmp_states = c()
tmp[[4]]=c(1.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[21]]=c(1.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[38]]=c(1.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[55]]=c(1.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[72]]=c(1.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[89]]=c(1.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[106]]=c(1.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[123]]=c(1.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[140]]=c(1.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[157]]=c(1.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[174]]=c(1.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp = do.call('rbind', tmp)
feat[[4]] = tmp[, ord]
feat_states[[4]] = tmp_states
tmp = vector(mode = 'list', length = 11)
tmp_states = c()
tmp[[5]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[22]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[39]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[56]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[73]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[90]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[107]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[124]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[141]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[158]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[175]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp = do.call('rbind', tmp)
feat[[5]] = tmp[, ord]
feat_states[[5]] = tmp_states
tmp = vector(mode = 'list', length = 11)
tmp_states = c()
tmp[[6]]=c(1.3851090669631958, 1.3851090669631958,1.3851090669631958,0.9084912538528442,0.9084912538528442,1.3851090669631958,0.9084912538528442,1.3851090669631958,1.3851090669631958,1.3851090669631958,2.011204242706299,0.9084912538528442,0.9084912538528442,0.9084912538528442,1.3851090669631958,0.9084912538528442,1.3851090669631958,1.3851090669631958,0.9084912538528442,1.0472419261932373,0.9084912538528442,1.3851090669631958)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[23]]=c(1.3851090669631958, 1.3851090669631958,1.3851090669631958,0.9084912538528442,0.9084912538528442,1.3851090669631958,0.9084912538528442,1.3851090669631958,1.3851090669631958,1.3851090669631958,2.011204242706299,0.9084912538528442,0.9084912538528442,0.9084912538528442,1.3851090669631958,0.9084912538528442,1.3851090669631958,1.3851090669631958,0.9084912538528442,1.0472419261932373,0.9084912538528442,1.3851090669631958)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[40]]=c(1.3851090669631958, 1.3851090669631958,1.3851090669631958,0.9084912538528442,0.9084912538528442,1.3851090669631958,0.9084912538528442,1.3851090669631958,1.3851090669631958,1.3851090669631958,2.011204242706299,0.9084912538528442,0.9084912538528442,0.9084912538528442,1.3851090669631958,0.9084912538528442,1.3851090669631958,1.3851090669631958,0.9084912538528442,1.0472419261932373,0.9084912538528442,1.3851090669631958)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[57]]=c(1.3851090669631958, 1.3851090669631958,1.3851090669631958,0.9084912538528442,0.9084912538528442,1.3851090669631958,0.9084912538528442,1.3851090669631958,1.3851090669631958,1.3851090669631958,2.011204242706299,0.9084912538528442,0.9084912538528442,0.9084912538528442,1.3851090669631958,0.9084912538528442,1.3851090669631958,1.3851090669631958,0.9084912538528442,1.0472419261932373,0.9084912538528442,1.3851090669631958)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[74]]=c(1.3851090669631958, 1.3851090669631958,1.3851090669631958,0.9084912538528442,0.9084912538528442,1.3851090669631958,0.9084912538528442,1.3851090669631958,1.3851090669631958,1.3851090669631958,2.011204242706299,0.9084912538528442,0.9084912538528442,0.9084912538528442,1.3851090669631958,0.9084912538528442,1.3851090669631958,1.3851090669631958,0.9084912538528442,1.0472419261932373,0.9084912538528442,1.3851090669631958)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[91]]=c(1.3851090669631958, 1.3851090669631958,1.3851090669631958,0.9084912538528442,0.9084912538528442,1.3851090669631958,0.9084912538528442,1.3851090669631958,1.3851090669631958,1.3851090669631958,2.011204242706299,0.9084912538528442,0.9084912538528442,0.9084912538528442,1.3851090669631958,0.9084912538528442,1.3851090669631958,1.3851090669631958,0.9084912538528442,1.0472419261932373,0.9084912538528442,1.3851090669631958)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[108]]=c(1.3851090669631958, 1.3851090669631958,1.3851090669631958,0.9084912538528442,0.9084912538528442,1.3851090669631958,0.9084912538528442,1.3851090669631958,1.3851090669631958,1.3851090669631958,2.011204242706299,0.9084912538528442,0.9084912538528442,0.9084912538528442,1.3851090669631958,0.9084912538528442,1.3851090669631958,1.3851090669631958,0.9084912538528442,1.0472419261932373,0.9084912538528442,1.3851090669631958)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[125]]=c(1.3851090669631958, 1.3851090669631958,1.3851090669631958,0.9084912538528442,0.9084912538528442,1.3851090669631958,0.9084912538528442,1.3851090669631958,1.3851090669631958,1.3851090669631958,2.011204242706299,0.9084912538528442,0.9084912538528442,0.9084912538528442,1.3851090669631958,0.9084912538528442,1.3851090669631958,1.3851090669631958,0.9084912538528442,1.0472419261932373,0.9084912538528442,1.3851090669631958)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[142]]=c(1.3851090669631958, 1.3851090669631958,1.3851090669631958,0.9084912538528442,0.9084912538528442,1.3851090669631958,0.9084912538528442,1.3851090669631958,1.3851090669631958,1.3851090669631958,2.011204242706299,0.9084912538528442,0.9084912538528442,0.9084912538528442,1.3851090669631958,0.9084912538528442,1.3851090669631958,1.3851090669631958,0.9084912538528442,1.0472419261932373,0.9084912538528442,1.3851090669631958)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[159]]=c(1.3851090669631958, 1.3851090669631958,1.3851090669631958,0.9084912538528442,0.9084912538528442,1.3851090669631958,0.9084912538528442,1.3851090669631958,1.3851090669631958,1.3851090669631958,2.011204242706299,0.9084912538528442,0.9084912538528442,0.9084912538528442,1.3851090669631958,0.9084912538528442,1.3851090669631958,1.3851090669631958,0.9084912538528442,1.0472419261932373,0.9084912538528442,1.3851090669631958)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[176]]=c(1.3851090669631958, 1.3851090669631958,1.3851090669631958,0.9084912538528442,0.9084912538528442,1.3851090669631958,0.9084912538528442,1.3851090669631958,1.3851090669631958,1.3851090669631958,2.011204242706299,0.9084912538528442,0.9084912538528442,0.9084912538528442,1.3851090669631958,0.9084912538528442,1.3851090669631958,1.3851090669631958,0.9084912538528442,1.0472419261932373,0.9084912538528442,1.3851090669631958)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp = do.call('rbind', tmp)
feat[[6]] = tmp[, ord]
feat_states[[6]] = tmp_states
tmp = vector(mode = 'list', length = 11)
tmp_states = c()
tmp[[7]]=c(0.25894632935523987, 0.25894632935523987,0.25894632935523987,-0.7903926372528076,-0.7903926372528076,0.25894632935523987,-0.7903926372528076,0.25894632935523987,0.25894632935523987,0.25894632935523987,0.1748787760734558,-0.7903926372528076,-0.7903926372528076,-0.7903926372528076,0.25894632935523987,-0.7903926372528076,0.25894632935523987,0.25894632935523987,-0.7903926372528076,-0.5529146790504456,-0.7903926372528076,0.25894632935523987)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[24]]=c(0.25894632935523987, 0.25894632935523987,0.25894632935523987,-0.7903926372528076,-0.7903926372528076,0.25894632935523987,-0.7903926372528076,0.25894632935523987,0.25894632935523987,0.25894632935523987,0.1748787760734558,-0.7903926372528076,-0.7903926372528076,-0.7903926372528076,0.25894632935523987,-0.7903926372528076,0.25894632935523987,0.25894632935523987,-0.7903926372528076,-0.5529146790504456,-0.7903926372528076,0.25894632935523987)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[41]]=c(0.25894632935523987, 0.25894632935523987,0.25894632935523987,-0.7903926372528076,-0.7903926372528076,0.25894632935523987,-0.7903926372528076,0.25894632935523987,0.25894632935523987,0.25894632935523987,0.1748787760734558,-0.7903926372528076,-0.7903926372528076,-0.7903926372528076,0.25894632935523987,-0.7903926372528076,0.25894632935523987,0.25894632935523987,-0.7903926372528076,-0.5529146790504456,-0.7903926372528076,0.25894632935523987)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[58]]=c(0.25894632935523987, 0.25894632935523987,0.25894632935523987,-0.7903926372528076,-0.7903926372528076,0.25894632935523987,-0.7903926372528076,0.25894632935523987,0.25894632935523987,0.25894632935523987,0.1748787760734558,-0.7903926372528076,-0.7903926372528076,-0.7903926372528076,0.25894632935523987,-0.7903926372528076,0.25894632935523987,0.25894632935523987,-0.7903926372528076,-0.5529146790504456,-0.7903926372528076,0.25894632935523987)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[75]]=c(0.25894632935523987, 0.25894632935523987,0.25894632935523987,-0.7903926372528076,-0.7903926372528076,0.25894632935523987,-0.7903926372528076,0.25894632935523987,0.25894632935523987,0.25894632935523987,0.1748787760734558,-0.7903926372528076,-0.7903926372528076,-0.7903926372528076,0.25894632935523987,-0.7903926372528076,0.25894632935523987,0.25894632935523987,-0.7903926372528076,-0.5529146790504456,-0.7903926372528076,0.25894632935523987)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[92]]=c(0.25894632935523987, 0.25894632935523987,0.25894632935523987,-0.7903926372528076,-0.7903926372528076,0.25894632935523987,-0.7903926372528076,0.25894632935523987,0.25894632935523987,0.25894632935523987,0.1748787760734558,-0.7903926372528076,-0.7903926372528076,-0.7903926372528076,0.25894632935523987,-0.7903926372528076,0.25894632935523987,0.25894632935523987,-0.7903926372528076,-0.5529146790504456,-0.7903926372528076,0.25894632935523987)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[109]]=c(0.25894632935523987, 0.25894632935523987,0.25894632935523987,-0.7903926372528076,-0.7903926372528076,0.25894632935523987,-0.7903926372528076,0.25894632935523987,0.25894632935523987,0.25894632935523987,0.1748787760734558,-0.7903926372528076,-0.7903926372528076,-0.7903926372528076,0.25894632935523987,-0.7903926372528076,0.25894632935523987,0.25894632935523987,-0.7903926372528076,-0.5529146790504456,-0.7903926372528076,0.25894632935523987)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[126]]=c(0.25894632935523987, 0.25894632935523987,0.25894632935523987,-0.7903926372528076,-0.7903926372528076,0.25894632935523987,-0.7903926372528076,0.25894632935523987,0.25894632935523987,0.25894632935523987,0.1748787760734558,-0.7903926372528076,-0.7903926372528076,-0.7903926372528076,0.25894632935523987,-0.7903926372528076,0.25894632935523987,0.25894632935523987,-0.7903926372528076,-0.5529146790504456,-0.7903926372528076,0.25894632935523987)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[143]]=c(0.25894632935523987, 0.25894632935523987,0.25894632935523987,-0.7903926372528076,-0.7903926372528076,0.25894632935523987,-0.7903926372528076,0.25894632935523987,0.25894632935523987,0.25894632935523987,0.1748787760734558,-0.7903926372528076,-0.7903926372528076,-0.7903926372528076,0.25894632935523987,-0.7903926372528076,0.25894632935523987,0.25894632935523987,-0.7903926372528076,-0.5529146790504456,-0.7903926372528076,0.25894632935523987)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[160]]=c(0.25894632935523987, 0.25894632935523987,0.25894632935523987,-0.7903926372528076,-0.7903926372528076,0.25894632935523987,-0.7903926372528076,0.25894632935523987,0.25894632935523987,0.25894632935523987,0.1748787760734558,-0.7903926372528076,-0.7903926372528076,-0.7903926372528076,0.25894632935523987,-0.7903926372528076,0.25894632935523987,0.25894632935523987,-0.7903926372528076,-0.5529146790504456,-0.7903926372528076,0.25894632935523987)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[177]]=c(0.25894632935523987, 0.25894632935523987,0.25894632935523987,-0.7903926372528076,-0.7903926372528076,0.25894632935523987,-0.7903926372528076,0.25894632935523987,0.25894632935523987,0.25894632935523987,0.1748787760734558,-0.7903926372528076,-0.7903926372528076,-0.7903926372528076,0.25894632935523987,-0.7903926372528076,0.25894632935523987,0.25894632935523987,-0.7903926372528076,-0.5529146790504456,-0.7903926372528076,0.25894632935523987)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp = do.call('rbind', tmp)
feat[[7]] = tmp[, ord]
feat_states[[7]] = tmp_states
feat_ord = feat[consrank2]
feat_states_ord = feat_states[consrank2]
shap_heatmap(shap_ord, baseline, rates_ord, species_names_ord, feat_ord,
             feat_names_ord, feat_states_ord, rate_type = 'extinction', n_individual_pred = 3)

dev.off()