pdf(file='C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_no_predictors/D_bdnn_update/combined_10_contribution_per_species_rates.pdf', width = 7, height = 6, useDingbats = FALSE, pointsize = 7)

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

plot(1:5, 1:5, type = 'n', main = 'No shap values available when there is only one predictor')
plot(1:5, 1:5, type = 'n', main = 'No shap values available when there is only one predictor')
dev.off()