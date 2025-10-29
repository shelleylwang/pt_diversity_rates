pdf(file='C:/Users/SimoesLabAdmin/Documents/pt_diversity_rates/updated_occurrence_analyses/model_3/synapsida/combined_10_contribution_per_species_rates.pdf', width = 7, height = 6, useDingbats = FALSE, pointsize = 7)

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

consrank=c(3.0, 0.0,2.0,1.0,4.0,5.0)
consrank2 = order(consrank, decreasing = FALSE)
consrank = order(consrank, decreasing = TRUE)
shap_list = list()
shap_list[[1]]=c(0.017221891577912627, 0.008059756276779809,0.017221891577912627,0.008059756276779809,0.008059756276779809,0.008059756276779809,0.008059756276779809,0.017221891577912627,-0.13699337859302438,-0.13699337859302438,0.008059756276779809,0.008059756276779809,0.017221891577912627,0.017221891577912627,0.017221891577912627,-0.2167291476437822,-0.2167291476437822,0.008059756071888842)
shap_list[[2]]=c(0.31320530359393783, -0.7774725293507799,0.31320530359393783,-0.7774725293507799,-0.7774725293507799,-0.7774725293507799,-0.7774725293507799,0.31320530359393783,0.34448318486721324,0.34448318486721324,-0.7774725293507799,-0.7774725293507799,0.31320530359393783,0.31320530359393783,0.31320530359393783,-0.5062150824069976,-0.5062150824069976,-0.7774725293507799)
shap_list[[3]]=c(0.06361960354975421, 0.11785518849268556,0.06361960354975421,0.11785518849268556,0.11785518849268556,0.11785518849268556,0.11785518849268556,0.06361960354975421,0.07310901836433151,0.07310901836433151,0.11785518849268556,0.11785518849268556,0.06361960354975421,0.06361960354975421,0.06361960354975421,0.10239451135508716,0.10239451135508716,0.1178551884368062)
shap_list[[4]]=c(-0.11841924659781149, 0.12879099231678992,-0.11841924659781149,0.12879099231678992,0.12879099231678992,0.12879099231678992,0.12879099231678992,-0.11841924659781149,-0.009116903798021854,-0.009116903798021854,0.12879099231678992,0.12879099231678992,-0.11841924659781149,-0.11841924659781149,-0.11841924659781149,0.04316778622334823,0.04316778622334823,0.1287909921258688)
shap_list[[5]]=c(0.017904623272625268, 0.040217961405287495,0.017904623272625268,0.040217961405287495,0.040217961405287495,0.040217961405287495,0.040217961405287495,0.017904623272625268,0.01834690165357055,0.01834690165357055,0.040217961405287495,0.040217961405287495,0.017904623272625268,0.017904623272625268,0.017904623272625268,0.031988420301931914,0.031988420301931914,0.04021796131215524)
shap_list[[6]]=c(0.018676142422358256, 0.04325405011884868,0.018676142422358256,0.04325405011884868,0.04325405011884868,0.04325405011884868,0.04325405011884868,0.018676142422358256,0.019087618813814444,0.019087618813814444,0.04325405011884868,0.04325405011884868,0.018676142422358256,0.018676142422358256,0.018676142422358256,0.03391521128534805,0.03391521128534805,0.0432540510315448)
shap = do.call('cbind', shap_list)
baseline = 0.46161743611097333
rate=c(1.5451695605565328, 0.4116093050991185,1.5451695605565328,0.4116093050991185,0.4116093050991185,0.4116093050991185,0.4116093050991185,1.5451695605565328,1.288620996037971,1.288620996037971,0.4116093050991185,0.4116093050991185,1.5451695605565328,1.5451695605565328,1.5451695605565328,0.2553761107329046,0.2553761107329046,0.41160930395824835)
rate_lwr=c(0.6500270664691925, 0.17210878059267998,0.6500270664691925,0.17210878059267998,0.17210878059267998,0.17210878059267998,0.17210878059267998,0.6500270664691925,0.5001069838181138,0.5001069838181138,0.17210878059267998,0.17210878059267998,0.6500270664691925,0.6500270664691925,0.6500270664691925,0.12198031321167946,0.12198031321167946,0.17210878059267998)
rate_upr=c(2.4982909709215164, 0.6254307143390179,2.4982909709215164,0.6254307143390179,0.6254307143390179,0.6254307143390179,0.6254307143390179,2.4982909709215164,2.4864135198295116,2.4864135198295116,0.6254307143390179,0.6254307143390179,2.4982909709215164,2.4982909709215164,2.4982909709215164,0.4084222633391619,0.4084222633391619,0.6254307143390179)
rates = cbind(rate, rate_lwr, rate_upr)
species_names = c()
species_names = c(species_names, 'Anomocephalus')
species_names = c(species_names, 'Archaeosyodon')
species_names = c(species_names, 'Australosyodon')
species_names = c(species_names, 'Biarmosuchoides')
species_names = c(species_names, 'Chthomaloporus')
species_names = c(species_names, 'Davletkulia')
species_names = c(species_names, 'Dinosaurus')
species_names = c(species_names, 'Eodicynodon')
species_names = c(species_names, 'Glanosuchus')
species_names = c(species_names, 'Ictidosaurus')
species_names = c(species_names, 'Molybdopygus')
species_names = c(species_names, 'Otsheria')
species_names = c(species_names, 'Pampaphoneus')
species_names = c(species_names, 'Patranomodon')
species_names = c(species_names, 'Tapinocaninus')
species_names = c(species_names, 'Titanophoneus')
species_names = c(species_names, 'Ulemica')
species_names = c(species_names, 'Venyukovia')
feat_names = c()
feat_names = c(feat_names, 'lat_range_z_trans')
feat_names = c(feat_names, 'Temperate_N')
feat_names = c(feat_names, 'Tropical')
feat_names = c(feat_names, 'Temperate_S')
feat_names = c(feat_names, 'Antarctic')
feat_names = c(feat_names, 'time')
ord = ord_by_importance(shap, consrank, rate)
shap_ord = shap[ord, consrank2, drop = FALSE]
rates_ord = rates[ord, ]
species_names_ord = species_names[ord]
feat_names_ord = feat_names[consrank2]
feat = vector(mode = 'list', length = 6)
feat_states = vector(mode = 'list', length = 6)
tmp = vector(mode = 'list', length = 8)
tmp_states = c()
tmp[[1]]=c(-0.2974245548248291, -0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.1407773196697235,-0.1407773196697235,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.13867215812206268,-0.13867215812206268,-0.2974245548248291)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[14]]=c(-0.2974245548248291, -0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.1407773196697235,-0.1407773196697235,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.13867215812206268,-0.13867215812206268,-0.2974245548248291)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[27]]=c(-0.2974245548248291, -0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.1407773196697235,-0.1407773196697235,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.13867215812206268,-0.13867215812206268,-0.2974245548248291)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[40]]=c(-0.2974245548248291, -0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.1407773196697235,-0.1407773196697235,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.13867215812206268,-0.13867215812206268,-0.2974245548248291)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[53]]=c(-0.2974245548248291, -0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.1407773196697235,-0.1407773196697235,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.13867215812206268,-0.13867215812206268,-0.2974245548248291)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[66]]=c(-0.2974245548248291, -0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.1407773196697235,-0.1407773196697235,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.13867215812206268,-0.13867215812206268,-0.2974245548248291)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[79]]=c(-0.2974245548248291, -0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.1407773196697235,-0.1407773196697235,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.13867215812206268,-0.13867215812206268,-0.2974245548248291)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[92]]=c(-0.2974245548248291, -0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.1407773196697235,-0.1407773196697235,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.13867215812206268,-0.13867215812206268,-0.2974245548248291)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp = do.call('rbind', tmp)
feat[[1]] = tmp[, ord]
feat_states[[1]] = tmp_states
tmp = vector(mode = 'list', length = 8)
tmp_states = c()
tmp[[2]]=c(0.0, 1.0,0.0,1.0,1.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[15]]=c(0.0, 1.0,0.0,1.0,1.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[28]]=c(0.0, 1.0,0.0,1.0,1.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[41]]=c(0.0, 1.0,0.0,1.0,1.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[54]]=c(0.0, 1.0,0.0,1.0,1.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[67]]=c(0.0, 1.0,0.0,1.0,1.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[80]]=c(0.0, 1.0,0.0,1.0,1.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[93]]=c(0.0, 1.0,0.0,1.0,1.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp = do.call('rbind', tmp)
feat[[2]] = tmp[, ord]
feat_states[[2]] = tmp_states
tmp = vector(mode = 'list', length = 8)
tmp_states = c()
tmp[[3]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[16]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[29]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[42]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[55]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[68]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[81]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[94]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp = do.call('rbind', tmp)
feat[[3]] = tmp[, ord]
feat_states[[3]] = tmp_states
tmp = vector(mode = 'list', length = 8)
tmp_states = c()
tmp[[4]]=c(1.0, 0.0,1.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[17]]=c(1.0, 0.0,1.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[30]]=c(1.0, 0.0,1.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[43]]=c(1.0, 0.0,1.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[56]]=c(1.0, 0.0,1.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[69]]=c(1.0, 0.0,1.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[82]]=c(1.0, 0.0,1.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[95]]=c(1.0, 0.0,1.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp = do.call('rbind', tmp)
feat[[4]] = tmp[, ord]
feat_states[[4]] = tmp_states
tmp = vector(mode = 'list', length = 8)
tmp_states = c()
tmp[[5]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[18]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[31]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[44]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[57]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[70]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[83]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[96]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp = do.call('rbind', tmp)
feat[[5]] = tmp[, ord]
feat_states[[5]] = tmp_states
tmp = vector(mode = 'list', length = 8)
tmp_states = c()
tmp[[13]]=c(269.24935560075755, 269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755)
tmp_states = c(tmp_states, 'time')
tmp[[26]]=c(269.24935560075755, 269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755)
tmp_states = c(tmp_states, 'time')
tmp[[39]]=c(269.24935560075755, 269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755)
tmp_states = c(tmp_states, 'time')
tmp[[52]]=c(269.24935560075755, 269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755)
tmp_states = c(tmp_states, 'time')
tmp[[65]]=c(269.24935560075755, 269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755)
tmp_states = c(tmp_states, 'time')
tmp[[78]]=c(269.24935560075755, 269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755)
tmp_states = c(tmp_states, 'time')
tmp[[91]]=c(269.24935560075755, 269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755)
tmp_states = c(tmp_states, 'time')
tmp[[104]]=c(269.24935560075755, 269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755)
tmp_states = c(tmp_states, 'time')
tmp = do.call('rbind', tmp)
feat[[6]] = tmp[, ord]
feat_states[[6]] = tmp_states
feat_ord = feat[consrank2]
feat_states_ord = feat_states[consrank2]
shap_heatmap(shap_ord, baseline, rates_ord, species_names_ord, feat_ord,
             feat_names_ord, feat_states_ord, rate_type = 'speciation', n_individual_pred = 3)

consrank=c(2.0, 0.0,3.0,1.0,5.0,4.0)
consrank2 = order(consrank, decreasing = FALSE)
consrank = order(consrank, decreasing = TRUE)
shap_list = list()
shap_list[[1]]=c(0.07516311138053425,0.07516311138053425)
shap_list[[2]]=c(-0.3821129238069989,-0.3821129238069989)
shap_list[[3]]=c(0.0958427345778182,0.0958427345778182)
shap_list[[4]]=c(0.1411302134837024,0.1411302134837024)
shap_list[[5]]=c(0.013791103555704468,0.013791103555704468)
shap_list[[6]]=c(0.013791107873548753,0.013791107873548753)
shap = do.call('cbind', shap_list)
baseline = 0.2701186527684331
rate=c(0.35184393183408247,0.35184393183408247)
rate_lwr=c(0.1457412801682949,0.1457412801682949)
rate_upr=c(0.5271315667778254,0.5271315667778254)
rates = cbind(rate, rate_lwr, rate_upr)
species_names = c()
species_names = c(species_names, 'Davletkulia')
species_names = c(species_names, 'Raranimus')
feat_names = c()
feat_names = c(feat_names, 'lat_range_z_trans')
feat_names = c(feat_names, 'Temperate_N')
feat_names = c(feat_names, 'Tropical')
feat_names = c(feat_names, 'Temperate_S')
feat_names = c(feat_names, 'Antarctic')
feat_names = c(feat_names, 'time')
ord = ord_by_importance(shap, consrank, rate)
shap_ord = shap[ord, consrank2, drop = FALSE]
rates_ord = rates[ord, ]
species_names_ord = species_names[ord]
feat_names_ord = feat_names[consrank2]
feat = vector(mode = 'list', length = 6)
feat_states = vector(mode = 'list', length = 6)
tmp = vector(mode = 'list', length = 8)
tmp_states = c()
tmp[[1]]=c(-0.2974245548248291,-0.2974245548248291)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[14]]=c(-0.2974245548248291,-0.2974245548248291)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[27]]=c(-0.2974245548248291,-0.2974245548248291)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[40]]=c(-0.2974245548248291,-0.2974245548248291)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[53]]=c(-0.2974245548248291,-0.2974245548248291)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[66]]=c(-0.2974245548248291,-0.2974245548248291)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[79]]=c(-0.2974245548248291,-0.2974245548248291)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[92]]=c(-0.2974245548248291,-0.2974245548248291)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp = do.call('rbind', tmp)
feat[[1]] = tmp[, ord]
feat_states[[1]] = tmp_states
tmp = vector(mode = 'list', length = 8)
tmp_states = c()
tmp[[2]]=c(1.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[15]]=c(1.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[28]]=c(1.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[41]]=c(1.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[54]]=c(1.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[67]]=c(1.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[80]]=c(1.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[93]]=c(1.0,1.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp = do.call('rbind', tmp)
feat[[2]] = tmp[, ord]
feat_states[[2]] = tmp_states
tmp = vector(mode = 'list', length = 8)
tmp_states = c()
tmp[[3]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[16]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[29]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[42]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[55]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[68]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[81]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[94]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp = do.call('rbind', tmp)
feat[[3]] = tmp[, ord]
feat_states[[3]] = tmp_states
tmp = vector(mode = 'list', length = 8)
tmp_states = c()
tmp[[4]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[17]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[30]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[43]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[56]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[69]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[82]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[95]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp = do.call('rbind', tmp)
feat[[4]] = tmp[, ord]
feat_states[[4]] = tmp_states
tmp = vector(mode = 'list', length = 8)
tmp_states = c()
tmp[[5]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[18]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[31]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[44]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[57]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[70]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[83]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[96]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp = do.call('rbind', tmp)
feat[[5]] = tmp[, ord]
feat_states[[5]] = tmp_states
tmp = vector(mode = 'list', length = 8)
tmp_states = c()
tmp[[13]]=c(269.24935560075755,269.24935560075755)
tmp_states = c(tmp_states, 'time')
tmp[[26]]=c(269.24935560075755,269.24935560075755)
tmp_states = c(tmp_states, 'time')
tmp[[39]]=c(269.24935560075755,269.24935560075755)
tmp_states = c(tmp_states, 'time')
tmp[[52]]=c(269.24935560075755,269.24935560075755)
tmp_states = c(tmp_states, 'time')
tmp[[65]]=c(269.24935560075755,269.24935560075755)
tmp_states = c(tmp_states, 'time')
tmp[[78]]=c(269.24935560075755,269.24935560075755)
tmp_states = c(tmp_states, 'time')
tmp[[91]]=c(269.24935560075755,269.24935560075755)
tmp_states = c(tmp_states, 'time')
tmp[[104]]=c(269.24935560075755,269.24935560075755)
tmp_states = c(tmp_states, 'time')
tmp = do.call('rbind', tmp)
feat[[6]] = tmp[, ord]
feat_states[[6]] = tmp_states
feat_ord = feat[consrank2]
feat_states_ord = feat_states[consrank2]
shap_heatmap(shap_ord, baseline, rates_ord, species_names_ord, feat_ord,
             feat_names_ord, feat_states_ord, rate_type = 'extinction', n_individual_pred = 3)

dev.off()