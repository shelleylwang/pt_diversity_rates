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

consrank=c(2.0, 0.0,1.0,3.0,6.0,5.0,4.0)
consrank2 = order(consrank, decreasing = FALSE)
consrank = order(consrank, decreasing = TRUE)
shap_list = list()
shap_list[[1]]=c(0.2007044826261699,-0.14124139371690408)
shap_list[[2]]=c(-0.8223827255191282,0.3760904010956448)
shap_list[[3]]=c(0.17981017699465154,0.07963713972403755)
shap_list[[4]]=c(0.2919369740411639,-0.17961107750821695)
shap_list[[5]]=c(0.03223205571761355,0.008944983771583767)
shap_list[[6]]=c(0.08786710386979393,0.031601357314942465)
shap_list[[7]]=c(-0.17761246935173403,-0.06707614075877584)
shap = do.call('cbind', shap_list)
baseline = 0.20674009334295987
rate=c(0.3860803556832252,0.6646374810551788)
rate_lwr=c(0.053500168258324265,0.006437433883547783)
rate_upr=c(0.8833485618233681,1.8829703982919455)
rates = cbind(rate, rate_lwr, rate_upr)
species_names = c()
species_names = c(species_names, 'Lanthanosuchus')
species_names = c(species_names, 'Provelosaurus')
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
tmp[[1]]=c(-0.3368251919746399,-0.15131919085979462)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[18]]=c(-0.3368251919746399,-0.15131919085979462)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[35]]=c(-0.3368251919746399,-0.15131919085979462)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[52]]=c(-0.3368251919746399,-0.15131919085979462)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[69]]=c(-0.3368251919746399,-0.15131919085979462)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[86]]=c(-0.3368251919746399,-0.15131919085979462)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[103]]=c(-0.3368251919746399,-0.15131919085979462)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[120]]=c(-0.3368251919746399,-0.15131919085979462)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[137]]=c(-0.3368251919746399,-0.15131919085979462)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[154]]=c(-0.3368251919746399,-0.15131919085979462)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[171]]=c(-0.3368251919746399,-0.15131919085979462)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp = do.call('rbind', tmp)
feat[[1]] = tmp[, ord]
feat_states[[1]] = tmp_states
tmp = vector(mode = 'list', length = 11)
tmp_states = c()
tmp[[2]]=c(1.0,0.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[19]]=c(1.0,0.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[36]]=c(1.0,0.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[53]]=c(1.0,0.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[70]]=c(1.0,0.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[87]]=c(1.0,0.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[104]]=c(1.0,0.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[121]]=c(1.0,0.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[138]]=c(1.0,0.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[155]]=c(1.0,0.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[172]]=c(1.0,0.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp = do.call('rbind', tmp)
feat[[2]] = tmp[, ord]
feat_states[[2]] = tmp_states
tmp = vector(mode = 'list', length = 11)
tmp_states = c()
tmp[[3]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[20]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[37]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[54]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[71]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[88]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[105]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[122]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[139]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[156]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[173]]=c(0.0,0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp = do.call('rbind', tmp)
feat[[3]] = tmp[, ord]
feat_states[[3]] = tmp_states
tmp = vector(mode = 'list', length = 11)
tmp_states = c()
tmp[[4]]=c(0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[21]]=c(0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[38]]=c(0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[55]]=c(0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[72]]=c(0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[89]]=c(0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[106]]=c(0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[123]]=c(0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[140]]=c(0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[157]]=c(0.0,1.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[174]]=c(0.0,1.0)
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
tmp[[6]]=c(-1.2465863227844238,-0.9070969223976135)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[23]]=c(-1.2465863227844238,-0.9070969223976135)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[40]]=c(-1.2465863227844238,-0.9070969223976135)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[57]]=c(-1.2465863227844238,-0.9070969223976135)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[74]]=c(-1.2465863227844238,-0.9070969223976135)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[91]]=c(-1.2465863227844238,-0.9070969223976135)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[108]]=c(-1.2465863227844238,-0.9070969223976135)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[125]]=c(-1.2465863227844238,-0.9070969223976135)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[142]]=c(-1.2465863227844238,-0.9070969223976135)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[159]]=c(-1.2465863227844238,-0.9070969223976135)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[176]]=c(-1.2465863227844238,-0.9070969223976135)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp = do.call('rbind', tmp)
feat[[6]] = tmp[, ord]
feat_states[[6]] = tmp_states
tmp = vector(mode = 'list', length = 11)
tmp_states = c()
tmp[[7]]=c(0.12988388538360596,0.2586252987384796)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[24]]=c(0.12988388538360596,0.2586252987384796)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[41]]=c(0.12988388538360596,0.2586252987384796)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[58]]=c(0.12988388538360596,0.2586252987384796)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[75]]=c(0.12988388538360596,0.2586252987384796)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[92]]=c(0.12988388538360596,0.2586252987384796)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[109]]=c(0.12988388538360596,0.2586252987384796)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[126]]=c(0.12988388538360596,0.2586252987384796)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[143]]=c(0.12988388538360596,0.2586252987384796)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[160]]=c(0.12988388538360596,0.2586252987384796)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[177]]=c(0.12988388538360596,0.2586252987384796)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp = do.call('rbind', tmp)
feat[[7]] = tmp[, ord]
feat_states[[7]] = tmp_states
feat_ord = feat[consrank2]
feat_states_ord = feat_states[consrank2]
shap_heatmap(shap_ord, baseline, rates_ord, species_names_ord, feat_ord,
             feat_names_ord, feat_states_ord, rate_type = 'speciation', n_individual_pred = 3)

consrank=c(2.0, 0.0,1.0,3.0,6.0,5.0,4.0)
consrank2 = order(consrank, decreasing = FALSE)
consrank = order(consrank, decreasing = TRUE)
shap_list = list()
shap_list[[1]]=c(0.06522108353848156)
shap_list[[2]]=c(0.30119383735709804)
shap_list[[3]]=c(0.12946243646051245)
shap_list[[4]]=c(-0.368096456243152)
shap_list[[5]]=c(0.007804360310278083)
shap_list[[6]]=c(-0.023375218014291023)
shap_list[[7]]=c(0.0217059240530555)
shap = do.call('cbind', shap_list)
baseline = 0.21976392298936845
rate=c(0.5795397875196795)
rate_lwr=c(0.004342806525528431)
rate_upr=c(1.75278106238693)
rates = cbind(rate, rate_lwr, rate_upr)
species_names = c()
species_names = c(species_names, 'Tramuntanasaurus')
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
tmp[[1]]=c(-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[18]]=c(-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[35]]=c(-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[52]]=c(-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[69]]=c(-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[86]]=c(-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[103]]=c(-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[120]]=c(-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[137]]=c(-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[154]]=c(-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[171]]=c(-0.3368251919746399)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp = do.call('rbind', tmp)
feat[[1]] = tmp[, ord]
feat_states[[1]] = tmp_states
tmp = vector(mode = 'list', length = 11)
tmp_states = c()
tmp[[2]]=c(0.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[19]]=c(0.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[36]]=c(0.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[53]]=c(0.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[70]]=c(0.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[87]]=c(0.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[104]]=c(0.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[121]]=c(0.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[138]]=c(0.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[155]]=c(0.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[172]]=c(0.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp = do.call('rbind', tmp)
feat[[2]] = tmp[, ord]
feat_states[[2]] = tmp_states
tmp = vector(mode = 'list', length = 11)
tmp_states = c()
tmp[[3]]=c(0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[20]]=c(0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[37]]=c(0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[54]]=c(0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[71]]=c(0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[88]]=c(0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[105]]=c(0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[122]]=c(0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[139]]=c(0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[156]]=c(0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[173]]=c(0.0)
tmp_states = c(tmp_states, 'Tropical')
tmp = do.call('rbind', tmp)
feat[[3]] = tmp[, ord]
feat_states[[3]] = tmp_states
tmp = vector(mode = 'list', length = 11)
tmp_states = c()
tmp[[4]]=c(1.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[21]]=c(1.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[38]]=c(1.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[55]]=c(1.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[72]]=c(1.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[89]]=c(1.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[106]]=c(1.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[123]]=c(1.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[140]]=c(1.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[157]]=c(1.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[174]]=c(1.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp = do.call('rbind', tmp)
feat[[4]] = tmp[, ord]
feat_states[[4]] = tmp_states
tmp = vector(mode = 'list', length = 11)
tmp_states = c()
tmp[[5]]=c(0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[22]]=c(0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[39]]=c(0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[56]]=c(0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[73]]=c(0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[90]]=c(0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[107]]=c(0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[124]]=c(0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[141]]=c(0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[158]]=c(0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[175]]=c(0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp = do.call('rbind', tmp)
feat[[5]] = tmp[, ord]
feat_states[[5]] = tmp_states
tmp = vector(mode = 'list', length = 11)
tmp_states = c()
tmp[[6]]=c(-0.954184353351593)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[23]]=c(-0.954184353351593)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[40]]=c(-0.954184353351593)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[57]]=c(-0.954184353351593)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[74]]=c(-0.954184353351593)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[91]]=c(-0.954184353351593)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[108]]=c(-0.954184353351593)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[125]]=c(-0.954184353351593)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[142]]=c(-0.954184353351593)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[159]]=c(-0.954184353351593)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp[[176]]=c(-0.954184353351593)
tmp_states = c(tmp_states, 'mean_pt_1myr_z_trans')
tmp = do.call('rbind', tmp)
feat[[6]] = tmp[, ord]
feat_states[[6]] = tmp_states
tmp = vector(mode = 'list', length = 11)
tmp_states = c()
tmp[[7]]=c(-0.32901960611343384)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[24]]=c(-0.32901960611343384)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[41]]=c(-0.32901960611343384)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[58]]=c(-0.32901960611343384)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[75]]=c(-0.32901960611343384)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[92]]=c(-0.32901960611343384)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[109]]=c(-0.32901960611343384)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[126]]=c(-0.32901960611343384)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[143]]=c(-0.32901960611343384)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[160]]=c(-0.32901960611343384)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp[[177]]=c(-0.32901960611343384)
tmp_states = c(tmp_states, 'Mod_R_deltaTMyr_pt_1myr_z_trans')
tmp = do.call('rbind', tmp)
feat[[7]] = tmp[, ord]
feat_states[[7]] = tmp_states
feat_ord = feat[consrank2]
feat_states_ord = feat_states[consrank2]
shap_heatmap(shap_ord, baseline, rates_ord, species_names_ord, feat_ord,
             feat_names_ord, feat_states_ord, rate_type = 'extinction', n_individual_pred = 3)

dev.off()