
# Resultados de los partidos
res.match <- fb_match_results(country = "", gender = "M", season_end_year = 2024, tier = "", non_dom_league_url = "https://fbref.com/en/comps/14/history/Copa-Libertadores-Seasons")

write_parquet(res.match, "data/match_results.parquet")


# URL partidos de la copa
url.match <- fb_match_urls(country = "", gender = "M", season_end_year = 2024, tier = "", non_dom_league_url = "https://fbref.com/en/comps/14/history/Copa-Libertadores-Seasons")

# Datos por tipo (summary - passing - passing_types - defense - possession - misc - keeper)

url.final <- "https://fbref.com/en/matches/5e4ed85c/Atletico-Mineiro-Botafogo-RJ-November-30-2024-Copa-Libertadores"

stats.type <- c("summary","passing","passing_types","defense","possession","misc","keeper")

list.final <- lapply(stats.type, function(x) {
  fb_advanced_match_stats(match_url = url.final, stat_type = x, team_or_player = "team")
})

names(list.final) <- stats.type

# union
list.union <- lapply(names(parquet.files), function(x) {
  rbind(parquet.files[[x]],list.final[[x]])
})

names(list.union) <- names(parquet.files)

# guardamos en archivos parquet

map2(list.union, names.parquet, function(df, nameFile) {
  write_parquet(df, paste("data/new_data/", nameFile))
})