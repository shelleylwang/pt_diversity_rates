pdf(file='C:/Users/SimoesLabAdmin/Documents/pt_diversity_rates/updated_occurrence_analyses/model_7/isotopic_pt_1myr/synapsida/combined_10_contribution_per_species_rates.pdf', width = 7, height = 6, useDingbats = FALSE, pointsize = 7)

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

consrank=c(3.0, 0.0,1.0,2.0,4.0,5.0)
consrank2 = order(consrank, decreasing = FALSE)
consrank = order(consrank, decreasing = TRUE)
shap_list = list()
shap_list[[1]]=c(0.23757564137535508, 0.08282669241303107,0.09427081829868257,0.08282669241303107,0.09427081829868257,0.09427081829868257,0.09427081829868257,-0.2329702454339713,0.09427081829868257,0.08282669241303107,-0.37830802032346766,-0.37830802032346766,0.09427081829868257,0.09427081829868257,0.08282669241303107,0.08282669241303107,0.09427081829868257,0.08282669241303107,-0.2802100843191147,0.23757564167465253,0.09427081845700741,0.2375756399592068)
shap_list[[2]]=c(0.9883891450888685, 0.4341720146866615,-1.2172408433072268,0.4341720146866615,-1.2172408433072268,-1.2172408433072268,-1.2172408433072268,-1.1568421044200659,-1.2172408433072268,0.4341720146866615,1.057109254889699,1.057109254889699,-1.2172408433072268,-1.2172408433072268,0.4341720146866615,0.4341720146866615,-1.2172408433072268,0.4341720146866615,-1.1180049299448729,0.9883891463340396,-1.2172408444993197,0.9883891459430195)
shap_list[[3]]=c(-1.7455800864699478, 0.06451953242441694,0.15718178765848279,0.06451953242441694,0.15718178765848279,0.15718178765848279,0.15718178765848279,0.15980722127482294,0.15718178765848279,0.06451953242441694,0.1711222802814604,0.1711222802814604,0.15718178765848279,0.15718178765848279,0.06451953242441694,0.06451953242441694,0.15718178765848279,0.06451953242441694,0.1581530411168933,-1.745580088669027,0.1571817878074944,-1.7455800916943767)
shap_list[[4]]=c(0.7442860803053981, -0.221402257787856,0.7022092512180097,-0.221402257787856,0.7022092512180097,0.7022092512180097,0.7022092512180097,0.6805654839496128,0.7022092512180097,-0.221402257787856,-0.6514176537182448,-0.6514176537182448,0.7022092512180097,0.7022092512180097,-0.221402257787856,-0.221402257787856,0.7022092512180097,-0.221402257787856,0.6749288377165794,0.7442860812430486,0.702209251516033,0.7442860802303413)
shap_list[[5]]=c(0.050813434821396844, 0.019137079676311553,0.05591890151612461,0.019137079676311553,0.05591890151612461,0.05591890151612461,0.05591890151612461,0.06116746557876468,0.05591890151612461,0.019137079676311553,0.05714770606218095,0.05714770606218095,0.05591890151612461,0.05591890151612461,0.019137079676311553,0.019137079676311553,0.05591890151612461,0.019137079676311553,0.06144734313013032,0.050813434918104625,0.05591890155337751,0.05081343453475258)
shap_list[[6]]=c(0.0552278785365768, 0.020638268151125495,0.06309428231790662,0.020638268151125495,0.06309428231790662,0.06309428231790662,0.06309428231790662,0.06704455222934484,0.06309428231790662,0.020638268151125495,0.06183810134891101,0.06183810134891101,0.06309428231790662,0.06309428231790662,0.020638268151125495,0.020638268151125495,0.06309428231790662,0.020638268151125495,0.06679540235549211,0.055227877952290935,0.06309428172186017,0.05522788559889349)
shap = do.call('cbind', shap_list)
baseline = 0.44116786524653434
rate=c(1.0067975251236931, 1.8298843498615316,0.4858849372831173,1.8298843498615316,0.4858849372831173,0.4858849372831173,0.4858849372831173,0.22107389779528602,0.4858849372831173,1.8298843498615316,0.9790690084279049,0.9790690084279049,0.4858849372831173,0.4858849372831173,1.8298843498615316,1.8298843498615316,0.4858849372831173,1.8298843498615316,0.20466363911749796,1.0067975245276466,0.4858849364728667,1.0067975239269435)
rate_lwr=c(0.28859447315335274, 0.9751256555318832,0.27175508067011833,0.9751256555318832,0.27175508067011833,0.27175508067011833,0.27175508067011833,0.08908496424555779,0.27175508067011833,0.9751256555318832,0.26240058802068233,0.26240058802068233,0.27175508067011833,0.27175508067011833,0.9751256555318832,0.9751256555318832,0.27175508067011833,0.9751256555318832,0.1003761813044548,0.28859447315335274,0.27175508067011833,0.288594588637352)
rate_upr=c(1.9088799078017473, 3.367914564907551,0.7801831588149071,3.367914564907551,0.7801831588149071,0.7801831588149071,0.7801831588149071,0.3453534319996834,0.7801831588149071,3.367914564907551,1.813925214111805,1.813925214111805,0.7801831588149071,0.7801831588149071,3.367914564907551,3.367914564907551,0.7801831588149071,3.367914564907551,0.3145822659134865,1.9088799078017473,0.7801831588149071,1.9088799078017473)
rates = cbind(rate, rate_lwr, rate_upr)
species_names = c()
species_names = c(species_names, 'Angelosaurus')
species_names = c(species_names, 'Anomocephalus')
species_names = c(species_names, 'Archaeosyodon')
species_names = c(species_names, 'Australosyodon')
species_names = c(species_names, 'Biarmosuchoides')
species_names = c(species_names, 'Chthomaloporus')
species_names = c(species_names, 'Davletkulia')
species_names = c(species_names, 'Deuterosaurus')
species_names = c(species_names, 'Dinosaurus')
species_names = c(species_names, 'Eodicynodon')
species_names = c(species_names, 'Glanosuchus')
species_names = c(species_names, 'Ictidosaurus')
species_names = c(species_names, 'Molybdopygus')
species_names = c(species_names, 'Otsheria')
species_names = c(species_names, 'Pampaphoneus')
species_names = c(species_names, 'Patranomodon')
species_names = c(species_names, 'Raranimus')
species_names = c(species_names, 'Tapinocaninus')
species_names = c(species_names, 'Titanophoneus')
species_names = c(species_names, 'Varanodon')
species_names = c(species_names, 'Venyukovia')
species_names = c(species_names, 'Watongia')
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
tmp = vector(mode = 'list', length = 2)
tmp_states = c()
tmp[[1]]=c(-0.2974245548248291, -0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.17417509853839874,-0.2974245548248291,-0.2974245548248291,-0.1407773196697235,-0.1407773196697235,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.13867215812206268,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[8]]=c(-0.2974245548248291, -0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.17417509853839874,-0.2974245548248291,-0.2974245548248291,-0.1407773196697235,-0.1407773196697235,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.13867215812206268,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp = do.call('rbind', tmp)
feat[[1]] = tmp[, ord]
feat_states[[1]] = tmp_states
tmp = vector(mode = 'list', length = 2)
tmp_states = c()
tmp[[2]]=c(0.0, 0.0,1.0,0.0,1.0,1.0,1.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,0.0,0.0,1.0,0.0,1.0,0.0,1.0,0.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[9]]=c(0.0, 0.0,1.0,0.0,1.0,1.0,1.0,1.0,1.0,0.0,0.0,0.0,1.0,1.0,0.0,0.0,1.0,0.0,1.0,0.0,1.0,0.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp = do.call('rbind', tmp)
feat[[2]] = tmp[, ord]
feat_states[[2]] = tmp_states
tmp = vector(mode = 'list', length = 2)
tmp_states = c()
tmp[[3]]=c(1.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0,1.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[10]]=c(1.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0,1.0)
tmp_states = c(tmp_states, 'Tropical')
tmp = do.call('rbind', tmp)
feat[[3]] = tmp[, ord]
feat_states[[3]] = tmp_states
tmp = vector(mode = 'list', length = 2)
tmp_states = c()
tmp[[4]]=c(0.0, 1.0,0.0,1.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,1.0,1.0,0.0,1.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[11]]=c(0.0, 1.0,0.0,1.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,1.0,1.0,0.0,1.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp = do.call('rbind', tmp)
feat[[4]] = tmp[, ord]
feat_states[[4]] = tmp_states
tmp = vector(mode = 'list', length = 2)
tmp_states = c()
tmp[[5]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[12]]=c(0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp = do.call('rbind', tmp)
feat[[5]] = tmp[, ord]
feat_states[[5]] = tmp_states
tmp = vector(mode = 'list', length = 2)
tmp_states = c()
tmp[[7]]=c(269.24935560075755, 269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755)
tmp_states = c(tmp_states, 'time')
tmp[[14]]=c(269.24935560075755, 269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755)
tmp_states = c(tmp_states, 'time')
tmp = do.call('rbind', tmp)
feat[[6]] = tmp[, ord]
feat_states[[6]] = tmp_states
feat_ord = feat[consrank2]
feat_states_ord = feat_states[consrank2]
shap_heatmap(shap_ord, baseline, rates_ord, species_names_ord, feat_ord,
             feat_names_ord, feat_states_ord, rate_type = 'speciation', n_individual_pred = 3)

consrank=c(3.0, 0.0,2.0,1.0,5.0,4.0)
consrank2 = order(consrank, decreasing = FALSE)
consrank = order(consrank, decreasing = TRUE)
shap_list = list()
shap_list[[1]]=c(0.12219591375440358, 0.12219591375440358,0.12219591375440358,0.12219591375440358,0.0436940274450836)
shap_list[[2]]=c(-0.48550250291824343, -0.48550250291824343,-0.48550250291824343,-0.48550250291824343,0.2386025466709938)
shap_list[[3]]=c(0.21203644674271346, 0.21203644674271346,0.21203644674271346,0.21203644674271346,-0.16419866658690155)
shap_list[[4]]=c(0.2096474721096456, 0.2096474721096456,0.2096474721096456,0.2096474721096456,0.06314239515342517)
shap_list[[5]]=c(0.021219801539555192, 0.021219801539555192,0.021219801539555192,0.021219801539555192,0.004972081197789542)
shap_list[[6]]=c(0.021219801250845195, 0.021219801250845195,0.021219801250845195,0.021219801250845195,0.004972078625205848)
shap = do.call('cbind', shap_list)
baseline = 0.2011286249011755
rate=c(0.3656049619987607, 0.3656049619987607,0.3656049619987607,0.3656049619987607,1.0530139117012731)
rate_lwr=c(0.18161065597087145, 0.18161065597087145,0.18161065597087145,0.18161065597087145,0.3193810172379017)
rate_upr=c(0.539758026599884, 0.539758026599884,0.539758026599884,0.539758026599884,2.1404996309429407)
rates = cbind(rate, rate_lwr, rate_upr)
species_names = c()
species_names = c(species_names, 'Davletkulia')
species_names = c(species_names, 'Microsyodon')
species_names = c(species_names, 'Raranimus')
species_names = c(species_names, 'Sinophoneus')
species_names = c(species_names, 'Varanodon')
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
tmp = vector(mode = 'list', length = 2)
tmp_states = c()
tmp[[1]]=c(-0.2974245548248291, -0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp[[8]]=c(-0.2974245548248291, -0.2974245548248291,-0.2974245548248291,-0.2974245548248291,-0.2974245548248291)
tmp_states = c(tmp_states, 'lat_range_z_trans')
tmp = do.call('rbind', tmp)
feat[[1]] = tmp[, ord]
feat_states[[1]] = tmp_states
tmp = vector(mode = 'list', length = 2)
tmp_states = c()
tmp[[2]]=c(1.0, 1.0,1.0,1.0,0.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp[[9]]=c(1.0, 1.0,1.0,1.0,0.0)
tmp_states = c(tmp_states, 'Temperate_N')
tmp = do.call('rbind', tmp)
feat[[2]] = tmp[, ord]
feat_states[[2]] = tmp_states
tmp = vector(mode = 'list', length = 2)
tmp_states = c()
tmp[[3]]=c(0.0, 0.0,0.0,0.0,1.0)
tmp_states = c(tmp_states, 'Tropical')
tmp[[10]]=c(0.0, 0.0,0.0,0.0,1.0)
tmp_states = c(tmp_states, 'Tropical')
tmp = do.call('rbind', tmp)
feat[[3]] = tmp[, ord]
feat_states[[3]] = tmp_states
tmp = vector(mode = 'list', length = 2)
tmp_states = c()
tmp[[4]]=c(0.0, 0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp[[11]]=c(0.0, 0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Temperate_S')
tmp = do.call('rbind', tmp)
feat[[4]] = tmp[, ord]
feat_states[[4]] = tmp_states
tmp = vector(mode = 'list', length = 2)
tmp_states = c()
tmp[[5]]=c(0.0, 0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp[[12]]=c(0.0, 0.0,0.0,0.0,0.0)
tmp_states = c(tmp_states, 'Antarctic')
tmp = do.call('rbind', tmp)
feat[[5]] = tmp[, ord]
feat_states[[5]] = tmp_states
tmp = vector(mode = 'list', length = 2)
tmp_states = c()
tmp[[7]]=c(269.24935560075755, 269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755)
tmp_states = c(tmp_states, 'time')
tmp[[14]]=c(269.24935560075755, 269.24935560075755,269.24935560075755,269.24935560075755,269.24935560075755)
tmp_states = c(tmp_states, 'time')
tmp = do.call('rbind', tmp)
feat[[6]] = tmp[, ord]
feat_states[[6]] = tmp_states
feat_ord = feat[consrank2]
feat_states_ord = feat_states[consrank2]
shap_heatmap(shap_ord, baseline, rates_ord, species_names_ord, feat_ord,
             feat_names_ord, feat_states_ord, rate_type = 'extinction', n_individual_pred = 3)

dev.off()