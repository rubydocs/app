Baseline::External::Github.dispatch_workflow \
  "uplinkhq/scrapers",
  "scrape.yml",
  :main,
  source:,
  proxy:,
  scraping_id: scraping.id.to_s,
  options:     options.to_json
